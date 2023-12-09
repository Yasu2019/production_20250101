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

require 'rails/all'
require 'csv'
#require "importmap/rails"

module Myapp
  class Application < Rails::Application
    config.assets.enabled = true
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configure npm as the JavaScript package manager for cssbundling-rails
    #config.cssbundling.install_command = "npm install"

    # Other configuration settings...
    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    config.active_record.encryption.key_derivation_salt = ENV['KEY_DERIVATION_SALT']
    config.active_record.encryption.primary_key = ENV['PRIMARY_KEY']

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
