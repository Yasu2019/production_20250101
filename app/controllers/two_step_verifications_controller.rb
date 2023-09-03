class TwoStepVerificationsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    # セッションにotp_user_idが存在しない場合やユーザーが見つからない場合の処理を追加
    unless session[:otp_user_id] && User.exists?(id: session[:otp_user_id])
      flash[:alert] = "ユーザーが見つかりませんでした。もう一度ログインしてください。"
      redirect_to new_user_session_path # これはDeviseのログインページへのパスです
      return
    end
  
    @user = User.find(session[:otp_user_id])
  
    unless @user.otp_secret
      @user.update!(otp_secret: User.generate_otp_secret(32))
    end
  
    issuer = 'IATF16949'
    label = "#{issuer}:#{@user.email}"
  
    uri = @user.otp_provisioning_uri(label, issuer: issuer)
  
    Rails.logger.debug("URI: #{uri}")
  
    @qr_code = RQRCode::QRCode.new(uri)
      .as_png(resize_exactly_to: 200)
      .to_data_url
    
    # キャッシュジョブの開始をログに記録
  Rails.logger.info("Starting CacheDataJob for user ID: #{@user.id}")

  # QRコードが生成された直後にキャッシュジョブを呼び出す
  if CacheDataJob.perform_async(@user.id)
    # キャッシュの読み込みが成功した場合のログ
    Rails.logger.info("Successfully started CacheDataJob for user ID: #{@user.id}")
  else
    # キャッシュの読み込みが失敗した場合のログ
    Rails.logger.error("Failed to start CacheDataJob for user ID: #{@user.id}")
  end
  

    Rails.logger.debug("QR Code: #{@qr_code}")
  end
  

  def create
    @user = User.find(session[:otp_user_id])
  
    if @user.validate_and_consume_otp!(params[:otp_attempt])
      Rails.logger.info("Two-factor authentication succeeded for user #{@user.email}")
  
      @user.update!(otp_required_for_login: true)
      sign_in(@user)
      session.delete(:otp_user_id)

      flash.delete(:alert) # これを追加
  
      after_two_factor_authenticated  # ここでメール送信のメソッドを呼び出す
      Rails.logger.info("after_two_factor_authenticated method called.")
  
      redirect_to root_path
    else
      # ワンタイムパスワードが不正な場合のフラッシュメッセージを追加
      #flash.now[:alert] = '間違ったパスワードが入力されました'
      flash[:alert] = '間違ったパスワードが入力されました'

      issuer = 'IATF16949'
      label = "#{issuer}:#{@user.email}"
  
      uri = @user.otp_provisioning_uri(label, issuer: issuer)
  
      @qr_code = RQRCode::QRCode.new(uri)
        .as_png(resize_exactly_to: 200)
        .to_data_url
  
      render :new
    end
  end
  

  def after_two_factor_authenticated
    password = generate_random_password
    session[:download_password] = password  # これを追加
    DownloadMailer.send_download_password(current_user.email, password).deliver_now
    DownloadMailer.send_download_password('yasuhiro-suzuki@mitsui-s.com', password).deliver_now

    puts "DEBUG: after_two_factor_authenticated called. Generated password: #{password}"
    Rails.logger.info("after_two_factor_authenticated called. Generated password: #{password}")
  end
end
