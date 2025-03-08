# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :connection_id

    def connect
      Rails.logger.tagged("ApplicationCable") do
        begin
          self.connection_id = SecureRandom.uuid
          Rails.logger.info "=== Attempting to connect client with ID: #{connection_id} ==="
          Rails.logger.info "=== Request origin: #{request.origin} ==="
          Rails.logger.info "=== Request headers: #{request.headers.to_h.select { |k, _| k.starts_with?('HTTP_') }} ==="
          Rails.logger.info "=== Connection successful ==="
        rescue => e
          Rails.logger.error "=== Connection error: #{e.message} ==="
          Rails.logger.error "=== Backtrace: #{e.backtrace.join("\n")} ==="
          reject_unauthorized_connection
        end
      end
    end

    def disconnect
      Rails.logger.tagged("ApplicationCable") do
        Rails.logger.info "=== Client disconnected: #{connection_id} ==="
      end
    end

    private

    def find_verified_user
      true
    end
  end
end
