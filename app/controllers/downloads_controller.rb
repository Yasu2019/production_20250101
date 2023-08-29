class DownloadsController < ApplicationController
  before_action :find_product, only: [:verify_password, :download]

  def verify_password
    # BlobのIDをセッションに保存
    session[:download_blob_id] = params[:blob_id]
    # ここでは、単にパスワード入力フォームを表示するためのビューをレンダリングします。
    # 特定のロジックは必要ありません。
  end

  def download
    entered_password = params[:password]
    
    Rails.logger.info("Entered password: #{entered_password}")
    Rails.logger.info("Session password: #{session[:download_password]}")
    
    if entered_password == session[:download_password]
      # セッションからBlobのIDを取得
      blob_id = session[:download_blob_id]
      file_attachment = ActiveStorage::Attachment.find(blob_id)
      file = file_attachment.blob

      # ActiveStorage のサービスURLを使用してファイルをダウンロードさせます
      redirect_to rails_blob_url(file)
    else
      flash[:alert] = "Invalid password"
      render :verify_password
    end
  end
  
  private

  def find_product
    @product = Product.find(params[:id])
  end
end
