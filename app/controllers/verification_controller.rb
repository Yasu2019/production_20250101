# app/controllers/verification_controller.rb
class VerificationController < ApplicationController
  skip_before_action :authenticate_user!, only: [:verify]

  def verify
    user = User.find_by(verification_token: params[:token])
    Rails.logger.info("DEBUG: Found user: #{user.inspect}")
    Rails.logger.info("DEBUG: Token expiry time: #{user.token_expiry}") if user

    if user && user.token_expiry > Time.now
      # トークンをリセット
      user.update(verification_token: nil, token_expiry: nil)
      sign_in(user)
      redirect_to root_path
    else
      redirect_to new_user_session_path, alert: "トークンが無効または期限切れです。"
    end
  end
end
