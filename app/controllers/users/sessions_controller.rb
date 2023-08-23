# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end


  #【Rails】devise-two-factorを使った2段階認証の実装方法【初学者】
  #https://autovice.jp/articles/172

  # POST /resource/sign_in
  # 以下を追記
  def create
    @user = User.find_by(email: params[:user][:email])
    if @user.valid_password?(params[:user][:password])
      session[:otp_user_id] = @user.id

      # 修正: リダイレクト先のパスを変更
      redirect_to new_two_step_verification_path and return
    else
      flash.now[:alert] = 'Invalid Email or password.'
      render :new
    end
  end

   # 以下を追記
   def create_two_step_verification
    user = User.find(session[:otp_user_id])

    if user.validate_and_consume_otp!(params[:otp_attempt])
      sign_in(user)
      redirect_to root_path
    else
      render :users_new_two_step_verification
    end
  end

  



end
