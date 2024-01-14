require "test_helper"

class TwoStepVerificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user.update!(otp_secret: User.generate_otp_secret(32))
    sign_in @user
  end

  test "should get new" do
    get new_two_step_verification_path
    assert_response :success
  end

  test "should post create" do
    post two_step_verifications_path, params: { otp_attempt: '123456' }
    assert_response :redirect
  end
end