# frozen_string_literal: true

Rails.application.config.action_cable.disable_request_forgery_protection = true

Rails.application.config.action_cable.allowed_request_origins = [
  'http://localhost:3001',
  'http://127.0.0.1:3001',
  /https?:\/\/*\.nys-web\.net/,
  /https?:\/\/nys-web\.net/
]
