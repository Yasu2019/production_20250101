require 'rufus-scheduler'
require 'stackprof'

class Users::SessionsController < Devise::SessionsController
  ALLOWED_IPS = ['180.11.97.245']
  ALLOWED_EMAILS = ['yasuhiro-suzuki@mitsui-s.com', 'n_komiya@mitsui-s.com']

  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_token

  def new
    self.resource = resource_class.new
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end
  
  def create
    begin
      @user = User.find_by(email: params[:user][:email])

      unless ip_allowed? || ALLOWED_EMAILS.include?(params[:user][:email])
        flash.now[:alert] = '管理者以外はミツイ精密社外からログインできません'
        self.resource = resource_class.new
        render :new and return
      end
    
      if @user && @user.valid_password?(params[:user][:password])
        session[:otp_user_id] = @user.id
        redirect_to new_two_step_verification_path and return
      else
        self.resource = resource_class.new(sign_in_params)
        clean_up_passwords(resource)
        flash.now[:alert] = '無効なEmail又はパスワードです。'
        render :new
      end
    rescue ActiveRecord::ConnectionNotEstablished
      backup_file_path = backup_postgresql
      formatted_time = Time.now.strftime('%Y年%m月%d日 %H時%M分')
      flash[:alert] = "前回までのデータベースが消失したため、#{formatted_time}のバックアップデータで再開します。"
      system("/root/restore_latest_backup.sh #{backup_file_path}") # バックアップファイルのパスを渡します
      redirect_to new_user_session_path
    end
  end

  def create_two_step_verification
    user = User.find(session[:otp_user_id])

    if user && user.validate_and_consume_otp!(params[:otp_attempt])
      sign_in(user)
      redirect_to root_path
    else
      render :users_new_two_step_verification
    end
  end

  private

  def ip_allowed?
    return true if ALLOWED_EMAILS.include?(params[:user][:email])

    ALLOWED_IPS.any? do |allowed_ip|
      IPAddr.new(allowed_ip).include?(request.remote_ip)
    end
  end

  def handle_invalid_token
    flash.now[:alert] = '管理者以外はミツイ精密社外からログインできません'
    self.resource = resource_class.new
    render :new
  end

  def backup_postgresql
    backup_dir = Rails.root.join('db', 'backup')
    Dir.mkdir(backup_dir) unless Dir.exist?(backup_dir)

    db_config = Rails.configuration.database_configuration[Rails.env]
    backup_file = backup_dir.join("backup_#{Time.now.strftime('%Y%m%d%H%M%S')}.sql")
    database_name = db_config["database"]
    username = db_config["username"]
    password = db_config["password"]
    host = db_config["host"]

    `PGPASSWORD=#{password} pg_dump -U #{username} -h #{host} -F c -b -v -f #{backup_file} #{database_name}`

    backup_file
  end
end
