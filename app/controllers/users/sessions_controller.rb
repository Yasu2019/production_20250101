# frozen_string_literal: true

require 'open3'

module Users
  class SessionsController < Devise::SessionsController
    ALLOWED_IPS = ['180.11.97.245'].freeze
    ALLOWED_EMAILS = ['yasuhiro-suzuki@mitsui-s.com', 'n_komiya@mitsui-s.com'].freeze

    rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_token

    def new
      Rails.logger.debug "New session requested"
      self.resource = resource_class.new
      clean_up_passwords(resource)
      yield resource if block_given?
      respond_with(resource, serialize_options(resource))
    end

    def create
      Rails.logger.debug "Create session requested"
      Rails.logger.debug "Params: #{params.inspect}"
      @user = User.find_by(email: params[:user][:email])

      # デバッグ用のログ出力を追加
      Rails.logger.debug "IP: #{request.remote_ip}, Email: #{params[:user][:email]}"
      Rails.logger.debug "IP allowed: #{ip_allowed?}, Email allowed: #{ALLOWED_EMAILS.include?(params[:user][:email].downcase)}"
      Rails.logger.debug "User found: #{@user.inspect}"
      Rails.logger.debug "Password provided: #{params[:user][:password].present?}"
      Rails.logger.debug "Password valid: #{@user&.valid_password?(params[:user][:password])}"

      # 条件文を修正：IPアドレスまたはメールアドレスが許可リストにある場合にログインを許可
      unless ip_allowed? || ALLOWED_EMAILS.include?(params[:user][:email].downcase)
        Rails.logger.debug "Access denied due to IP or Email restrictions"
        flash.now[:alert] = '管理者以外はミツイ精密社外からログインできません'
        self.resource = resource_class.new
        render :new and return
      end

      if @user&.valid_password?(params[:user][:password])
        Rails.logger.debug "Password is valid, proceeding to two-step verification"
        session[:otp_user_id] = @user.id
        redirect_to new_two_step_verification_path and return
      else
        Rails.logger.debug "Invalid email or password"
        self.resource = resource_class.new(sign_in_params)
        clean_up_passwords(resource)
        flash.now[:alert] = '無効なEmail又はパスワードです。'
        render :new
      end
    end

    private

    def ip_allowed?
      ALLOWED_IPS.include?(request.remote_ip)
    end

    def handle_invalid_token
      Rails.logger.debug "Invalid authenticity token detected"
      flash[:alert] = 'セッションの有効期限が切れました。もう一度お試しください。'
      redirect_to new_user_session_path
    end

    def handle_db_connection_error
      Rails.logger.error "Database connection error occurred"
      backup_file_path = backup_postgresql
      formatted_time = Time.zone.now.strftime('%Y年%m月%d日 %H時%M分')
      flash[:alert] = "前回までのデータベースが消失したため、#{formatted_time}のバックアップデータで再開します。"
      restore_database(backup_file_path)
      redirect_to new_user_session_path
    end

    def restore_database(backup_file_path)
      Rails.logger.info "Attempting to restore database from #{backup_file_path}"
      # Open3を使用してシェルコマンドを実行
      Open3.popen3('/root/restore_latest_backup.sh', backup_file_path) do |_stdin, _stdout, stderr, wait_thr|
        exit_status = wait_thr.value
        unless exit_status.success?
          # エラー処理
          error_message = "データベースのリストアに失敗しました: #{stderr.read}"
          Rails.logger.error error_message
          raise error_message
        end
      end
      Rails.logger.info "Database restoration completed successfully"
    end

    def backup_postgresql
      Rails.logger.info "Initiating PostgreSQL backup"
      backup_dir = Rails.root.join('db/backup').to_s
      FileUtils.mkdir_p(backup_dir)

      db_config = Rails.configuration.database_configuration[Rails.env]
      timestamp = Time.zone.now.strftime('%Y%m%d%H%M%S')
      backup_file_name = "backup_#{timestamp}.sql"
      backup_file = File.join(backup_dir, backup_file_name)

      # pg_dumpコマンドを使用してバックアップを作成
      command = "PGPASSWORD=#{db_config['password']} pg_dump -h #{db_config['host']} -U #{db_config['username']} -d #{db_config['database']} -f #{backup_file}"
      Rails.logger.debug "Executing backup command: #{command}"
      
      system(command)

      if $?.success?
        Rails.logger.info "Backup created successfully: #{backup_file}"
      else
        Rails.logger.error "Backup creation failed"
      end

      backup_file
    end
  end
end