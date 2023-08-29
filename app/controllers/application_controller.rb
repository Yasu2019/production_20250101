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


  #3. 2要素認証成功後にメールを送信
  #devise-two-factorを使用している場合、2要素認証が成功した後に特定のコードを実行するためのコールバックを設定できます。
  #このコールバック内でメールを送信するコードを追加します。
  #これで、2要素認証が成功した後にダウンロードパスワードがメールで送信されるようになります。

  #最後に、SMTPの設定情報はセキュアに保管する必要があります。環境変数を使用するか、Railsのcredentialsを
  #使用してこれらの情報を保管してください。公開される可能性がある場所にこれらの情報を置かないようにしてください。

  def after_two_factor_authenticated
    password = generate_random_password
  
    session[:download_password] = password
    DownloadMailer.send_download_password(current_user.email, password).deliver_now
    DownloadMailer.send_download_password('yasuhiro-suzuki@mitsui-s.com', password).deliver_now

    puts "DEBUG: after_two_factor_authenticated called. Generated password: #{password}"
    Rails.logger.info("after_two_factor_authenticated called. Generated password: #{password}")
end


  private

  #generate_random_password メソッドは、複数のコントローラーで使用される可能性があるため、
  #共通のヘルパーメソッドとして定義するのが適切です。
  #以下の手順で進めてください：

  #1. ApplicationControllerにメソッドを追加
  #最も単純な方法として、app/controllers/application_controller.rb にこのメソッドを追加することができます。
  #これにより、すべてのコントローラーでこのメソッドを使用することができます。


  def generate_random_password
    chars = [('a'..'z'), ('A'..'Z'), ('0'..'9'), ['!', '@', '#', '$', '%', '^', '&', '*']].map(&:to_a).flatten
    (0...30).map { chars[rand(chars.length)] }.join
  end




end
