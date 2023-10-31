#!/bin/bash

# データベースの設定
DB_NAME="myapp_development"
DB_USER="postgres"
DB_PASSWORD="password"
DB_HOST="db"
BACKUP_DIR="/root/db/backup"

# 最新のバックアップファイルを取得
BACKUP_FILE=$(ls $BACKUP_DIR/backup_*.sql | sort -r | head -n 1)

# バックアップファイルが存在するか確認
if [[ ! -f "$BACKUP_FILE" ]]; then
  echo "Backup file not found!"
  exit 1
fi

# データベースをリストア
PGPASSWORD=$DB_PASSWORD pg_restore -h $DB_HOST -U $DB_USER -d $DB_NAME -1 $BACKUP_FILE

# エラーが発生した場合はメッセージを表示
if [[ $? -ne 0 ]]; then
  echo "Error restoring database!"
  exit 1
fi

echo "Database restored successfully from $BACKUP_FILE!"
