#!/usr/bin/env ruby
# Railsの環境を読み込む
require File.expand_path('../config/environment', __dir__)

# ローカルのファイル一覧を取得
local_files = Dir.glob(File.join(Rails.root, 'db', 'latest_documents', '*')).map { |f| File.basename(f) }

# Active Storageのblobsテーブルからファイル名を取得
db_files = ActiveStorage::Blob.all.map(&:filename)

# ローカルにあってDBに存在しないファイルを見つける
new_files = local_files - db_files

if new_files.empty?
  puts "新規ファイルはありません。"
else
  puts "新規ファイルがあります："
  new_files.each do |file|
    puts "- #{file}"
  end
end
