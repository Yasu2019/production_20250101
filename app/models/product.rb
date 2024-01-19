# frozen_string_literal: true

class Product < ApplicationRecord
  has_many_attached :documents

  # Ransack needs attributes explicitly allowlisted as searchableとエラーが出た時の対処法
  # https://zenn.dev/nagan/articles/e627918c192265

  def self.ransackable_attributes(_auth_object = nil)
    %w[category created_at deadline_at description documentcategory documentname documentnumber
       documentrev documenttype end_at goal_attainment_level id materialcode object partnumber phase stage start_time status tasseido updated_at]
  end

  # 【Ruby on Rails】CSVインポート
  # https://qiita.com/seitarooodayo/items/c9d6955a12ca0b1fd1d4

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
      product = find_by(id: row['id']) || new
      # CSVからデータを取得し、設定する
      product.attributes = row.to_hash.slice(*updatable_attributes)
      # 保存する
      product.save
    end
  end

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    %w[id partnumber materialcode documentname description category phase stage start_time
       deadline_at end_at goal_attainment_level status]
  end
end
