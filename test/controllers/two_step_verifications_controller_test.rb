require "test_helper"

class TwoStepVerificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) # users(:one) はテスト用のユーザーフィクスチャを指します
    @user.update!(otp_secret: User.generate_otp_secret(32))
    session[:otp_user_id] = @user.id
  end

  test "should get new" do
    get new_two_step_verification_url # 修正されたURLヘルパー
    assert_response :success
  end

  test "should post create" do
    # 有効なOTPを生成するか、User#validate_and_consume_otp!の結果をモックする
    valid_otp = '123456' # 有効なOTPをここで設定する

    post two_step_verifications_url, params: {
      otp_attempt: valid_otp
    }
    assert_redirected_to new_user_session_path
  end
end