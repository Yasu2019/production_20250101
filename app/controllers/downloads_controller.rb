# frozen_string_literal: true

class DownloadsController < ApplicationController
  def verify_password
    Rails.logger.debug { "params[:blob_id]: #{params[:blob_id]}" }

    Rails.logger.debug { "session[:download_blob_id]: #{session[:download_blob_id]}" }
    Rails.logger.debug { "Entered password: #{params[:password]}" }
    Rails.logger.debug { "Session password: #{session[:download_password]}" }

    @document = Product.find(params[:id])
    # ここにログ出力を追加
    Rails.logger.debug { "@document: #{@document.inspect}" }
    session[:download_blob_id] = params[:blob_id]

    blob_id = session[:download_blob_id]
    Rails.logger.debug { "Blob ID: #{blob_id}" }

    entered_password = params[:password]

    if entered_password == session[:download_password]
      file_attachment = ActiveStorage::Attachment.find_by(blob_id:)

      if file_attachment
        file = file_attachment.blob
        @download_url = rails_blob_url(file)
      else
        Rails.logger.warn("No attachment found for blob ID: #{blob_id}")
        flash[:alert] = 'ファイルが見つかりませんでした。'
        render :verify_password
        nil
      end
    else
      flash[:alert] = 'Invalid password'
      render :verify_password
    end
  end

  def download
    blob_id = session[:download_blob_id]
    file_attachment = ActiveStorage::Attachment.find_by(blob_id:)

    # エラーハンドリングを追加
    unless file_attachment
      Rails.logger.warn("No attachment found for blob ID: #{blob_id} during download action.")
      redirect_to root_path, alert: 'ダウンロードするファイルが見つかりませんでした。'
      return
    end

    file = file_attachment.blob
    send_data file.download, filename: file.filename.to_s, disposition: 'attachment'
  end
end
