# frozen_string_literal: true

class DocumentNotificationsChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "=== DocumentNotificationsChannel: Client attempting to subscribe ==="
    stream_from "document_notifications"
    Rails.logger.info "=== DocumentNotificationsChannel: Stream established ==="
    check_for_new_files
  end

  def unsubscribed
    Rails.logger.info "=== DocumentNotificationsChannel: Client unsubscribed ==="
  end

  def check_for_new_files
    Rails.logger.info "=== DocumentNotificationsChannel: Starting file check ==="
    
    watch_path = Rails.root.join('db', 'latest_documents')
    Rails.logger.info "=== DocumentNotificationsChannel: Watch path: #{watch_path} ==="
    
    unless Dir.exist?(watch_path)
      Rails.logger.info "=== DocumentNotificationsChannel: Creating directory #{watch_path} ==="
      FileUtils.mkdir_p(watch_path)
    end

    # データベースに登録されているファイル名を取得
    files_in_database = ActiveStorage::Attachment.pluck(:filename).map(&:to_s)
    Rails.logger.info "=== DocumentNotificationsChannel: Files in database: #{files_in_database.inspect} ==="

    # ディレクトリ内のファイルを取得
    files_in_directory = Dir.glob(File.join(watch_path, '*.{pdf,doc,docx,xls,xlsx}')).map { |f| File.basename(f) }
    Rails.logger.info "=== DocumentNotificationsChannel: Files in directory: #{files_in_directory.inspect} ==="

    # 新規ファイルを特定
    new_files = files_in_directory - files_in_database
    Rails.logger.info "=== DocumentNotificationsChannel: New files found: #{new_files.inspect} ==="

    # 新規ファイルがある場合はメッセージを送信
    if new_files.any?
      message = {
        type: 'new_files',
        files: new_files,
        timestamp: Time.current.to_i
      }
      Rails.logger.info "=== DocumentNotificationsChannel: Broadcasting message: #{message.inspect} ==="
      
      # ブロードキャストを試行
      begin
        ActionCable.server.broadcast("document_notifications", message)
        Rails.logger.info "=== DocumentNotificationsChannel: Message broadcast successful ==="
      rescue => e
        Rails.logger.error "=== DocumentNotificationsChannel: Error broadcasting message: #{e.message} ==="
        Rails.logger.error e.backtrace.join("\n")
      end
    else
      Rails.logger.info "=== DocumentNotificationsChannel: No new files to notify about ==="
    end
  rescue => e
    Rails.logger.error "=== DocumentNotificationsChannel: Error in check_for_new_files: #{e.message} ==="
    Rails.logger.error e.backtrace.join("\n")
  end

  # 定期的なファイルチェック（15秒ごと）
  periodically :check_for_new_files, every: 15.seconds
end
