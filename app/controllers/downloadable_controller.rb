class DownloadableController < ApplicationController
  before_action :set_downloadable

  def verify_password_post
    blob_id = params[:blob_id]
    entered_password = params[:password]
  
    if entered_password == session[:download_password]
      @document = ActiveStorage::Attachment.find_by(blob_id: blob_id)
  
      if @document
        file = @document.blob
        @download_url = rails_blob_url(file)
        # ファイルのダウンロードURLを提供するページをレンダリング
        render :download_page
      else
        Rails.logger.warn("No attachment found for blob ID: #{blob_id}")
        flash[:alert] = "ファイルが見つかりませんでした。"
        render :verify_password
      end
    else
      flash[:alert] = "Invalid password"
      render :verify_password
    end
  end

  def new
    begin
      @user = User.find(session[:otp_user_id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "ユーザーが見つかりませんでした。"
      redirect_to root_path
      return
    end
  end

  def verify_password
    Rails.logger.info("verify_password action called")
    Rails.logger.debug("params[:blob_id]: #{params[:blob_id]}")
    Rails.logger.debug("session[:download_blob_id]: #{session[:download_blob_id]}")
    Rails.logger.debug("Entered password: #{params[:password]}")
    Rails.logger.debug("Session password: #{session[:download_password]}")

    # パスワードが提供されていない場合、パスワード入力ページをレンダリング
    unless params[:password]
      @document = ActiveStorage::Attachment.find_by(blob_id: params[:blob_id])
      render :verify_password and return
    end

    session[:download_blob_id] = params[:blob_id]
    blob_id = session[:download_blob_id]
    Rails.logger.debug("Blob ID: #{blob_id}")

    entered_password = params[:password]

    if entered_password == session[:download_password]
      @document = ActiveStorage::Attachment.find_by(blob_id: params[:blob_id])

      if @document
        file = @document.blob
        @download_url = rails_blob_url(file)
        # ファイルのダウンロードURLを提供するページをレンダリング
        render :download_page
      else
        Rails.logger.warn("No attachment found for blob ID: #{blob_id}")
        flash[:alert] = "ファイルが見つかりませんでした。"
        render :verify_password
      end
    else
      flash[:alert] = "Invalid password"
      render :verify_password
    end
end



  def download
    blob_id = session[:download_blob_id]
    file_attachment = ActiveStorage::Attachment.find_by(blob_id: blob_id)

    # エラーハンドリングを追加
    unless file_attachment
      Rails.logger.warn("No attachment found for blob ID: #{blob_id} during download action.")
      redirect_to root_path, alert: "ダウンロードするファイルが見つかりませんでした。"
      return
    end

    file = file_attachment.blob
    send_data file.download, filename: file.filename.to_s, disposition: 'attachment'
  end

  private

  def set_downloadable
    model = if request.path.include?("/products/")
              Rails.logger.info("Model detected: Product")
              Product
            elsif request.path.include?("/suppliers/")
              Rails.logger.info("Model detected: Supplier")
              Supplier
            elsif request.path.include?("/touans/")
              Rails.logger.info("Model detected: Touan")
              Touan
            end
  
    if model
      @downloadable = model.find_by(id: params[:id])
      if @downloadable
        Rails.logger.info("Found #{@downloadable.class.name} with ID: #{params[:id]}")
      else
        Rails.logger.error("#{model.name} not found with ID: #{params[:id]}")
        redirect_to root_path, alert: "リクエストが無効です。"
      end
    else
      Rails.logger.error("Unknown controller in path: #{request.path}")
      redirect_to root_path, alert: "リクエストが無効です。"
    end
  end
  
  
  
  
end

