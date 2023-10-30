class MemoryUsageMailer < ApplicationMailer
  default from: 'mitsui.seimitsu.iatf16949@gmail.com'

  def send_memory_usage_with_success_message(email, current_memory, max_memory, min_memory, avg_memory, stackprof_results, estackprof_results) # estackprof_resultsを引数に追加
  
    @current_memory = current_memory
    @max_memory = max_memory
    @min_memory = min_memory
    @avg_memory = avg_memory
    @backup_message = "バックアップに成功しました"
    @stackprof_results = stackprof_results
    @estackprof_results = "保留"

    mail(to: email, subject: 'アプリのメモリ使用量の統計とデータベースバックアップの通知')
  end
end

