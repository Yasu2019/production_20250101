require "test_helper"

class TwoStepVerificationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # Deviseのテストヘルパーをインクルード

  setup do
    @user = users(:one)
    sign_in @user # ユーザーをサインイン
  end

  test "should get new" do
    get new_two_step_verification_url
    assert_response :success
  end

  test "should post create" do
    post two_step_verifications_url, params: { otp_attempt: '123456' }
    assert_response :redirect
  end
end
