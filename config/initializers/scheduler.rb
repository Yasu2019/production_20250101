require 'rufus-scheduler'
require 'stackprof'  # stackprofのrequire
#require 'estackprof'



# メモリ使用量の履歴を保存する配列（600エントリー分）
$memory_usages = []

scheduler = Rufus::Scheduler.singleton

def backup_postgresql
  # Ensure the backup directory exists
  backup_dir = Rails.root.join('db', 'backup')
  Dir.mkdir(backup_dir) unless Dir.exist?(backup_dir)

  # database.ymlの内容を読み込み
  db_config = Rails.configuration.database_configuration[Rails.env]

  backup_file = backup_dir.join("backup_#{Time.now.strftime('%Y%m%d%H%M%S')}.sql")
  database_name = db_config["database"]
  username = db_config["username"]
  password = db_config["password"]
  host = db_config["host"]

  # バックアップコマンドの実行
  `PGPASSWORD=#{password} pg_dump -U #{username} -h #{host} -F c -b -v -f #{backup_file} #{database_name}`

  backup_file
end

# 10秒ごとにメモリの使用量を取得
scheduler.every '60s' do
  memory_usage = `ps -o rss= -p #{Process.pid}`.to_i / 1024  # MB単位
  $memory_usages << memory_usage
  $memory_usages.shift if $memory_usages.length > 600  # 過去1時間（600エントリー）のデータのみ保持
end

# 3分ごとにメモリの使用量の統計とstackprofの結果を計算してメールを送信
scheduler.every '60m' do
  current_memory = $memory_usages.last
  max_memory = $memory_usages.max
  min_memory = $memory_usages.min
  avg_memory = $memory_usages.sum / $memory_usages.length.to_f


  # stackprofの実行と結果の取得
# mode: :object
StackProf.run(mode: :object, out: 'tmp/stackprof_object.dump') do
  User.all.load        # データベースから全ユーザーを取得
  Product.all.load     # データベースから全商品を取得
  Touan.all.load       # データベースから全てのTouanを取得
end
stackprof_object_results = `stackprof tmp/stackprof_object.dump --text`

# mode: :cpu
StackProf.run(mode: :cpu, out: 'tmp/stackprof_cpu.dump') do
  User.all.load        # データベースから全ユーザーを取得
  Product.all.load     # データベースから全商品を取得
  Touan.all.load       # データベースから全てのTouanを取得
end
stackprof_cpu_results = `stackprof tmp/stackprof_cpu.dump --text`

# estackprofの結果を取得
#estackprof_results = `estackprof top -c`
#estackprof_results = "保留"



# 結果の結合（メール送信のため）
stackprof_results = "Object Mode Results:\n#{stackprof_object_results}\n\nCPU Mode Results:\n#{stackprof_cpu_results}"


  # バックアップの取得
  backup_postgresql

  # メール送信
begin
  #MemoryUsageMailer.send_memory_usage_with_success_message('yasuhiro-suzuki@mitsui-s.com', current_memory, max_memory, min_memory, avg_memory, stackprof_results, estackprof_results).deliver_now
  MemoryUsageMailer.send_memory_usage_with_success_message('yasuhiro-suzuki@mitsui-s.com', current_memory, max_memory, min_memory, avg_memory, stackprof_results).deliver_now

  Rails.logger.info "メールが正常に送信されました"
rescue => e
  Rails.logger.error "メールの送信に失敗しました: #{e.message}"
end


end
