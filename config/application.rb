
#【Ruby on Rails】CSVインポート
#https://qiita.com/seitarooodayo/items/c9d6955a12ca0b1fd1d4
require 'rails/all'
require 'csv'

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application

   


    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    #【Rails】日本語化のやり方
    #https://qiita.com/mmaumtjgj/items/93ab3ef8cbcf9591fc30
    config.i18n.default_locale = :ja

    #Railsタイムゾーンまとめ
    #https://qiita.com/aosho235/items/a31b895ce46ee5d3b444

    #【Rails】Time.currentとTime.nowの違い
    #https://qiita.com/kodai_0122/items/111457104f83f1fb2259
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local



  end
end
