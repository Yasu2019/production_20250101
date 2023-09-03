# app/jobs/cache_update_job.rb
class CacheUpdateJob
  include Sidekiq::Worker

  def perform(user_id)
    # キャッシュの更新ロジック
    #products = Product.where.not(documentnumber: nil).includes(:documents_attachments)
    touans = Touan.where(user_id: user_id)
    #user = User.find(user_id)
    #auditor = user.auditor
    #iatf_data_audit = Iatf.where(audit: "2")
    #iatf_data_audit_sub = Iatf.where(audit: "1")
    #csrs = Csr.all
    #iatflists = Iatflist.all

    # キャッシュに保存
    #Rails.cache.write("products_#{user_id}", products)
    Rails.cache.write("touans_#{user_id}", touans)
    #Rails.cache.write("user_#{user_id}", user)
    #Rails.cache.write("auditor_#{user_id}", auditor)
    #Rails.cache.write("iatf_data_audit_#{user_id}", iatf_data_audit)
    #Rails.cache.write("iatf_data_audit_sub_#{user_id}", iatf_data_audit_sub)
    #Rails.cache.write("csrs", csrs)
    #Rails.cache.write("iatflists", iatflists)
  end
end

# app/models/touan.rb (または関連するモデル)
class Touan < ApplicationRecord
  after_save :update_cache

  private

  def update_cache
    # データが保存または更新されたときにキャッシュ更新ジョブをトリガー
    CacheUpdateJob.perform_async(self.user_id)
  end
end
