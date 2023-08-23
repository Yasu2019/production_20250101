class TwoStepVerificationsController < ApplicationController
  # 修正: 不要なコメントを削除
  #before_action :authenticate_user!
  skip_before_action :authenticate_user!

  def new
    def new
      @user = User.find(session[:otp_user_id])
    
      unless @user.otp_secret
        @user.update!(otp_secret: User.generate_otp_secret(32))
      end
    
      issuer = 'IATF16949'
      label = "#{issuer}:#{@user.email}"
    
      uri = @user.otp_provisioning_uri(label, issuer: issuer)  # ここを修正
    
      Rails.logger.debug("URI: #{uri}")
    
      @qr_code = RQRCode::QRCode.new(uri)
        .as_png(resize_exactly_to: 200)
        .to_data_url
    
      Rails.logger.debug("QR Code: #{@qr_code}")
    end
    
  end

  def create
    @user = User.find(session[:otp_user_id])
  
    if @user.validate_and_consume_otp!(params[:otp_attempt])
      @user.update!(otp_required_for_login: true)
      sign_in(@user) # ユーザーをログイン状態にする
      session.delete(:otp_user_id) # otp_user_id セッションを削除
      redirect_to root_path
    else
      issuer = 'IATF16949'
      label = "#{issuer}:#{@user.email}"
  
      uri = @user.otp_provisioning_uri(label, issuer: issuer)
  
      @qr_code = RQRCode::QRCode.new(uri)
        .as_png(resize_exactly_to: 200)
        .to_data_url
  
      render :new
    end
  end
  
  # 修正: 余分な end を削除
end
