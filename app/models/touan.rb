class Touan < ApplicationRecord
    validates :kaito, presence: true

     #【Ruby on Rails】CSVインポート
  #https://qiita.com/seitarooodayo/items/c9d6955a12ca0b1fd1d4

  def self.import_kaitou(file)
    CSV.foreach(file.path, headers: true) do |row|
       # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
      testkaitou = find_by(id: row["id"]) || new
      # CSVからデータを取得し、設定する
      testkaitou.attributes = row.to_hash.slice(*updatable_attributes)
         # 保存する
       testkaitou.save
     end
   end
  
  # 更新を許可するカラムを定義
   def self.updatable_attributes
     ["id","kajyou", "mondai_no","rev","mondai","mondai_a","mondai_b","mondai_c","seikai","kaisetsu","kaito","user_id","total_answers","correct_answers","seikairitsu","created_at","updated_at"]
   end
       
end


