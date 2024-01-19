# frozen_string_literal: true

# app/controllers/users/sessions_controller.rb
require 'rufus-scheduler'
require 'stackprof'
require 'open3'
require 'ipaddr'
require 'shellwords'

module Users
  class SessionsController < Devise::SessionsController
    ALLOWED_IPS = ['180.11.97.245'].freeze
    ALLOWED_EMAILS = ['yasuhiro-suzuki@mitsui-s.com', 'n_komiya@mitsui-s.com'].freeze

    rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_token

    def new
      self.resource = resource_class.new
      clean_up_passwords(resource)
      yield resource if block_given?
      respond_with(resource, serialize_options(resource))
    end

    def create
      @user = User.find_by(email: params[:user][:email])

      unless ip_allowed? || ALLOWED_EMAILS.include?(params[:user][:email])
        flash.now[:alert] = '管理者以外はミツイ精密社外からログインできません'
        self.resource = resource_class.new
        render :new and return
      end

      if @user&.valid_password?(params[:user][:password])
        session[:otp_user_id] = @user.id
        redirect_to new_two_step_verification_path and return
      else
        self.resource = resource_class.new(sign_in_params)
        clean_up_passwords(resource)
        flash.now[:alert] = '無効なEmail又はパスワードです。'
        render :new
      end
    rescue ActiveRecord::ConnectionNotEstablished
      handle_db_connection_error
    end

    def create_two_step_verification
      user = User.find(session[:otp_user_id])

      if user&.validate_and_consume_otp!(params[:otp_attempt])
        sign_in(user)
        redirect_to root_path
      else
        render :users_new_two_step_verification
      end
    end

    private

    def ip_allowed?
      ALLOWED_IPS.any? { |allowed_ip| IPAddr.new(allowed_ip).include?(request.remote_ip) }
    end

    def handle_invalid_token
      flash.now[:alert] = '管理者以外はミツイ精密社外からログインできません'
      self.resource = resource_class.new
      render :new
    end

    def handle_db_connection_error
      backup_file_path = backup_postgresql
      formatted_time = Time.zone.now.strftime('%Y年%m月%d日 %H時%M分')
      flash[:alert] = "前回までのデータベースが消失したため、#{formatted_time}のバックアップデータで再開します。"
      restore_database(backup_file_path)
      redirect_to new_user_session_path
    end

    def restore_database(backup_file_path)
      # Open3を使用してシェルコマンドを実行
      Open3.popen3('/root/restore_latest_backup.sh', backup_file_path) do |_stdin, _stdout, stderr, wait_thr|
        exit_status = wait_thr.value
        unless exit_status.success?
          # エラー処理
          raise "データベースのリストアに失敗しました: #{stderr.read}"
        end
      end
    end

    # app/controllers/users/sessions_controller.rb

    # ...

    def backup_postgresql
      backup_dir = Rails.root.join('db/backup').to_s
      Dir.mkdir(backup_dir) unless Dir.exist?(backup_dir)

      db_config = Rails.configuration.database_configuration[Rails.env]
      timestamp = Time.zone.now.strftime('%Y%m%d%H%M%S')
      backup_file_name = "backup_#{timestamp}.sql"
      backup_file = File.join(backup_dir, backup_file_name)

      # タイムスタンプが適切なフォーマットであることを確認
      raise 'Invalid filename' unless backup_file_name =~ /\Abackup_\d{14}\.sql\z/

      database_name = db_config['database']
      username = Shellwords.escape(db_config['username'])
      password = Shellwords.escape(db_config['password'])
      host = Shellwords.escape(db_config['host'])

      # pg_dumpコマンドを実行するための環境変数を設定
      env = { 'PGPASSWORD' => password }

      # Open3を使用してシェルコマンドを実行
      command = ['pg_dump', '-U', username, '-h', host, '-F', 'c', '-b', '-v', '-f', backup_file, database_name]

      Open3.popen3(env, *command.map { |arg| Shellwords.escape(arg) }) do |stdin, _stdout, stderr, wait_thr|
        stdin.close # stdinは使用しないため閉じる
        # コマンドの実行結果を待つ
        exit_status = wait_thr.value
        unless exit_status.success?
          # エラー処理
          raise "バックアップに失敗しました: #{stderr.read}"
        end
      end

      backup_file
    end
  end
end
