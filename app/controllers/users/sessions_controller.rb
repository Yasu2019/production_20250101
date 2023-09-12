# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # ミツイ精密社内IPアドレスのみアクセス許可
  ALLOWED_IPS = ['192.168.5.0/24', '8.8.8.8']
  ALLOWED_EMAILS = ['yasuhiro-suzuki@mitsui-s.com', 'n_komiya@mitsui-s.com']

  def create
    # 制限のロジックを追加
    unless ALLOWED_IPS.include?(request.remote_ip) || ALLOWED_EMAILS.include?(params[:user][:email])
      flash.now[:alert] = '管理者以外はミツイ精密社外からログインできません'
      render :new and return
    end

    @user = User.find_by(email: params[:user][:email])

    if @user && @user.valid_password?(params[:user][:password])
      session[:otp_user_id] = @user.id
      redirect_to new_two_step_verification_path and return
    else
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      flash.now[:alert] = '無効なEmail又はパスワードです。'
      render :new
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
end
