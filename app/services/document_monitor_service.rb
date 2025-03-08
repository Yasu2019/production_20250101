# frozen_string_literal: true
require 'singleton'
require 'digest'
require 'listen'

class DocumentMonitorService
  include Singleton

  @@listener = nil
  @@running = false

  def initialize
    @watch_path = Rails.root.join('db', 'latest_documents')
    @notification_duration = ENV.fetch('NOTIFICATION_DURATION', '15').to_i
    @enabled = ENV.fetch('ENABLE_DOCUMENT_MONITOR', 'true').downcase == 'true'
    @logger = Rails.logger
    @logger.level = :debug

    @logger.info "[DocumentMonitorService] Configuration:"
    @logger.info "  - Watch path: #{@watch_path}"
    @logger.info "  - Notification duration: #{@notification_duration} seconds"
    @logger.info "  - Enabled: #{@enabled}"
  end

  def self.start
    instance.start_monitoring
  end

  def self.stop
    instance.stop_monitoring
  end

  def start_monitoring
    return if @@running
    return unless @enabled

    @logger.info "[DocumentMonitorService] Starting service..."
    @logger.info "[DocumentMonitorService] Watch path: #{@watch_path}"

    # 監視ディレクトリが存在しない場合は作成
    FileUtils.mkdir_p(@watch_path) unless Dir.exist?(@watch_path)

    @@running = true
    
    # ファイルシステムの監視を開始
    @@listener = Listen.to(@watch_path, only: /\.(pdf|doc|docx|xls|xlsx)$/) do |modified, added, removed|
      handle_file_changes(modified, added, removed)
    end

    # リスナーを開始
    @@listener.start
    @logger.info "[DocumentMonitorService] File system listener started"
  end

  def stop_monitoring
    return unless @@running

    @logger.info "[DocumentMonitorService] Stopping service..."
    @@running = false
    @@listener&.stop
    @@listener = nil
    @logger.info "[DocumentMonitorService] Service stopped"
  end

  private

  def handle_file_changes(modified, added, removed)
    current_time = Time.current
    
    # 新規ファイルの処理
    added.each do |file|
      @logger.info "[DocumentMonitorService] New file detected: #{file}"
      process_new_file(file, current_time)
    end

    # 変更されたファイルの処理
    modified.each do |file|
      @logger.info "[DocumentMonitorService] File modified: #{file}"
      process_new_file(file, current_time)
    end

    # 削除されたファイルの処理
    removed.each do |file|
      @logger.info "[DocumentMonitorService] File removed: #{file}"
    end
  end

  def process_new_file(file, detected_at)
    filename = File.basename(file)
    @logger.info "[DocumentMonitorService] Processing new/modified file: #{filename}"
    
    begin
      # ファイルの基本情報を取得
      stat = File.stat(file)
      file_size = stat.size
      file_type = File.extname(file).downcase[1..-1]
      
      # 通知メッセージを作成
      message = {
        type: 'notification',
        filename: filename,
        message: "新しいドキュメントが検出されました: #{filename}",
        timestamp: detected_at.to_i,
        notificationDuration: @notification_duration,
        details: {
          path: file,
          size: file_size,
          type: file_type,
          modified_at: stat.mtime.strftime('%Y-%m-%d %H:%M:%S'),
          detected_at: detected_at.strftime('%Y-%m-%d %H:%M:%S')
        }
      }

      @logger.info "[DocumentMonitorService] Broadcasting message: #{message.inspect}"
      
      # WebSocketで通知を送信
      ActionCable.server.broadcast(
        "document_notifications_channel",
        message
      )

      @logger.info "[DocumentMonitorService] Broadcast successful for file: #{filename}"
    rescue => e
      @logger.error "[DocumentMonitorService] Error broadcasting notification for #{filename}: #{e.message}"
      @logger.error "[DocumentMonitorService] #{e.backtrace.join("\n")}"
    end
  end
end
