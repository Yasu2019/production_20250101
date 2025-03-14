# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
Rails.application.config.assets.paths << Rails.root.join("node_modules")
Rails.application.config.assets.paths << Rails.root.join("app/javascript")
Rails.application.config.assets.paths << Rails.root.join("app/javascript/channels")

# Precompile additional assets.
Rails.application.config.assets.precompile += %w( 
  application.js
  channels/index.js
  channels/consumer.js
  channels/document_notifications_channel.js
  controllers/application.js
  controllers/index.js
  *.png 
  *.jpg
)

# Enable compiling JavaScript modules
Rails.application.config.assets.js_compressor = nil
