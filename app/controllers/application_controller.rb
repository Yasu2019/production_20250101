class ApplicationController < ActionController::Base

  #ユーザがログインしているかどうかを確認し、ログインしていない場合はユーザをログインページにリダイレクトする。
  #https://qiita.com/gogotakataka1234/items/c7d5c0b3d8953216259e
  
  before_action :authenticate_user!  #追加

  #deviseのログイン後、ログアウト後のリダイレクト先を設定する方法
  #https://qiita.com/qo_op/items/2974088e9c8c7a1b4075

  # ログアウト後のリダイレクト先
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path #ここを好きなパスに変更
  end


end
