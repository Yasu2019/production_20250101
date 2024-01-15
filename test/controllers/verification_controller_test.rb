require "test_helper"

class VerificationControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user_with_valid_token = users(:valid_token_user) # 有効なトークンを持つユーザー
    @user_with_expired_token = users(:expired_token_user) # 期限切れのトークンを持つユーザー
    # テストユーザーをここで作成またはfixturesで定義してください。
  end

  test "should verify user with valid token" do
    # 有効なトークンを持つユーザーでverifyアクションをテスト
    get verify_token_path(token: @user_with_valid_token.verification_token)
    assert_redirected_to root_path
  end

  test "should not verify user with expired token" do
    # 期限切れのトークンを持つユーザーでverifyアクションをテスト
    get verify_token_path(token: @user_with_expired_token.verification_token)
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_equal "トークンが期限切れです。", flash[:alert]
  end

  test "should not verify user with invalid token" do
    # 存在しないトークンでverifyアクションをテスト
    get verify_token_path(token: "nonexistenttoken")
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_equal "トークンが存在しません。", flash[:alert]
  end
end