# frozen_string_literal: true

Rails.application.config.after_initialize do
  Rails.logger.info "[DocumentMonitor Initializer] Starting document monitor service..."

  # 既存のサービスを停止
  begin
    DocumentMonitorService.stop
    Rails.logger.info "[DocumentMonitor Initializer] Stopped existing service"
  rescue => e
    Rails.logger.error "[DocumentMonitor Initializer] Error stopping service: #{e.message}"
  end

  # 新しいサービスを開始
  begin
    DocumentMonitorService.start
    Rails.logger.info "[DocumentMonitor Initializer] Started new service"
  rescue => e
    Rails.logger.error "[DocumentMonitor Initializer] Error starting service: #{e.message}"
  end

  Rails.logger.info "[DocumentMonitor Initializer] Initialization complete"
end

# サーバー終了時の処理
at_exit do
  Rails.logger.info "[DocumentMonitor Initializer] Stopping document monitor service..."
  DocumentMonitorService.stop
  Rails.logger.info "[DocumentMonitor Initializer] Service stopped"
end
