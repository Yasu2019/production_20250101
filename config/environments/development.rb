require "active_support/core_ext/integer/time"

Rails.application.configure do


  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  #letter_opener_web gem は、開発環境で送信されるメールをブラウザ上で確認できるようにするためのgemです。
  #Docker環境でもローカル開発環境でも使用できます。
  #Docker環境で letter_opener_web を使用する場合、次の手順を参考に設定することができます：
  #config.action_mailer.delivery_method = :letter_opener_web
  config.action_mailer.delivery_method = :smtp

  config.after_initialize do
    Bullet.enable        = true
    Bullet.alert         = true
    Bullet.bullet_logger = true
    Bullet.console       = true
    Bullet.rails_logger  = true
    Bullet.add_footer    = true
  end

  #Net::SMTPAuthenticationError に関連する "Must issue a STARTTLS command first" エラーは、
  #SMTPサーバーがTLS接続を要求していることを示しています。GmailのSMTPサーバーは、TLS接続を要求するため、
  #このエラーが発生するのは理解できます。
  #この問題を解決するためには、SMTP設定でTLS接続を明示的に有効にする必要があります。
  #しかし、既に :enable_starttls_auto => true を設定しているため、
  #この設定だけでは問題が解決しない可能性があります。
  #別のアプローチとして、Mail gem や letter_opener gem などの他のメーリングライブラリを使用することで、
  #開発環境でのメール送信をシミュレートすることができます。
  #letter_opener gemを使用する方法:

  #config.action_mailer.delivery_method = :letter_opener
  #config.action_mailer.perform_deliveries = true



  
  config.action_mailer.smtp_settings = {
    :enable_starttls_auto => true,
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => 'smtp.gmail.com',
    :user_name => ENV['SMTP_USERNAME'],
    :password => ENV['SMTP_PASSWORD'],
    #:user_name => "mitsui.seimitsu.iatf16949@gmail.com",
    #:password => "aodwtnulqohgdgvf",
    :authentication => 'plain',
    :openssl_verify_mode => 'none' # この行を追加します
    
  }

  


  config.middleware.use Bullet::Rack

  config.hosts << "nys-web.net"
  
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true
end
