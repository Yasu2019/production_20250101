# frozen_string_literal: true

module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def subscribed
      Rails.logger.tagged("ApplicationCable") do
        Rails.logger.info "=== Channel subscribed: #{self.class.name} ==="
        Rails.logger.info "=== Connection ID: #{connection.connection_id} ==="
      rescue StandardError => e
        Rails.logger.error "Error subscribing to channel: #{e.message}"
      end
    end

    def unsubscribed
      Rails.logger.tagged("ApplicationCable") do
        Rails.logger.info "=== Channel unsubscribed: #{self.class.name} ==="
        Rails.logger.info "=== Connection ID: #{connection.connection_id} ==="
      rescue StandardError => e
        Rails.logger.error "Error unsubscribing from channel: #{e.message}"
      end
    end
  end
end
