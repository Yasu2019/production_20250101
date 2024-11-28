# frozen_string_literal: true

require 'csv'
require 'logger'

# ロガーの設定
logger = Logger.new(STDOUT)
logger.level = Logger::INFO
logger.formatter = proc do |severity, datetime, progname, msg|
  "#{datetime}: #{severity} -- #{msg}\n"
end

# グローバル変数を使用してカウンターを管理
$row_count = 0
$error_count = 0
BATCH_SIZE = 50  # 100から50に変更

# ファイル添付用のヘルパーメソッド
def attach_file(record, file_path, filename, logger)
  return unless File.file?(file_path)
  
  begin
    file_content = File.binread(file_path)
    record.documents.attach(
      io: StringIO.new(file_content),
      filename: filename
    )
    logger.info "ファイルを添付しました: #{filename}"
  rescue Errno::ENOENT
    logger.error "ファイルが見つかりません: #{file_path}"
  rescue Errno::EACCES
    logger.error "ファイルへのアクセス権がありません: #{file_path}"
  rescue Errno::EMFILE
    logger.error "開いているファイルの数が多すぎます: #{file_path}"
  rescue => e
    logger.error "ファイルの添付に失敗しました: #{file_path}、エラー: #{e.message}"
  end
end

begin
  logger.info "=== シードデータの作成を開始します ==="
  start_time = Time.current

  # メインの製品データ処理
  logger.info "--- 製品データの処理を開始します ---"
  rows = []
  CSV.foreach(Rails.root.join('db/record/attachedfile.csv'), headers: true) do |row|
    rows << row
    if rows.size >= BATCH_SIZE
      ActiveRecord::Base.transaction do
        rows.each do |r|
          $row_count += 1
          begin
            product = Product.find_or_initialize_by(documentnumber: r['documentnumber']&.strip)
            
            # 基本属性の設定
            attributes = %w[
              category partnumber materialcode phase stage description status
              documenttype documentname documentrev documentcategory start_time
              deadline_at end_at goal_attainment_level tasseido object
            ]
            
            attributes.each do |attr|
              product.send("#{attr}=", r[attr])
            end

            # ファイル添付処理
            if r['filename'].present?
              file_path = Rails.root.join("db/documents/#{r['filename']}")
              attach_file(product, file_path, r['filename'], logger)
            end

            unless product.save
              $error_count += 1
              logger.error "行 #{$row_count}: 製品の保存に失敗しました。ドキュメント番号: #{product.documentnumber}。" \
                         "エラー: #{product.errors.full_messages.join(', ')}"
            end
          rescue => e
            $error_count += 1
            logger.error "行 #{$row_count}: エラーが発生しました: #{e.message}"
          end
        end
      end
      
      # バッチ処理後のクリーンアップ
      GC.start # ガベージコレクションを明示的に実行
      sleep(0.1) # 0.1秒の待機時間を追加
      
      logger.info "#{$row_count}件の処理が完了しました（処理時間: #{Time.current - start_time}秒）"
      rows = []
    end
  end

  # 残りのレコードを処理
  if rows.any?
    ActiveRecord::Base.transaction do
      rows.each do |r|
        $row_count += 1
        begin
          product = Product.find_or_initialize_by(documentnumber: r['documentnumber']&.strip)
          
          attributes = %w[
            category partnumber materialcode phase stage description status
            documenttype documentname documentrev documentcategory start_time
            deadline_at end_at goal_attainment_level tasseido object
          ]
          
          attributes.each do |attr|
            product.send("#{attr}=", r[attr])
          end

          if r['filename'].present?
            file_path = Rails.root.join("db/documents/#{r['filename']}")
            attach_file(product, file_path, r['filename'], logger)
          end

          unless product.save
            $error_count += 1
            logger.error "行 #{$row_count}: 製品の保存に失敗しました。ドキュメント番号: #{product.documentnumber}。" \
                       "エラー: #{product.errors.full_messages.join(', ')}"
          end
        rescue => e
          $error_count += 1
          logger.error "行 #{$row_count}: エラーが発生しました: #{e.message}"
        end
      end
    end
    GC.start
  end

  logger.info "製品データの処理完了。合計 #{$row_count} 行を処理しました。エラー数: #{$error_count}"

  # Phase データの更新
  logger.info "--- Phaseデータの更新を開始します ---"
  phase_count = 0
  CSV.foreach('db/category.csv').each_slice(BATCH_SIZE) do |batch_rows|
    ActiveRecord::Base.transaction do
      batch_rows.each do |row|
        begin
          phase = Phase.find_or_initialize_by(id: row[0])
          phase.update(name: row[1], ancestry: row[2])
          phase_count += 1
          logger.info "Phaseデータを更新しました: ID #{row[0]}" if phase_count % BATCH_SIZE == 0
        rescue => e
          logger.error "Phaseデータの更新に失敗しました: ID #{row[0]}, エラー: #{e.message}"
        end
      end
    end
    GC.start
    sleep(0.1)
  end

  # User データの更新
  logger.info "--- Userデータの更新を開始します ---"
  user_count = 0
  CSV.foreach('db/record/login.csv').each_slice(BATCH_SIZE) do |batch_rows|
    ActiveRecord::Base.transaction do
      batch_rows.each do |row|
        begin
          user = User.find_or_initialize_by(id: row[0])
          user.update(
            email: row[1],
            password: row[2],
            name: row[3],
            role: row[4],
            owner: row[5],
            auditor: row[6]
          )
          user_count += 1
          logger.info "Userデータを更新しました: ID #{row[0]}" if user_count % BATCH_SIZE == 0
        rescue => e
          logger.error "Userデータの更新に失敗しました: ID #{row[0]}, エラー: #{e.message}"
        end
      end
    end
    GC.start
    sleep(0.1)
  end

  # Measurementequipment データの作成
  logger.info "--- Measurementequipmentデータの作成を開始します ---"
  equipment_count = 0
  CSV.foreach('db/record/measurement_equipment.csv').each_slice(BATCH_SIZE) do |batch_rows|
    ActiveRecord::Base.transaction do
      batch_rows.each do |row|
        begin
          equipment = Measurementequipment.new
          attributes = {
            categories: row[0],
            scope_of_internal_testing_laboratories: row[1],
            product_measurement_item: row[2],
            measuring_range: row[3],
            measuring_instrument_test_equipment: row[4],
            manufacturer: row[5],
            equipment_model_name: row[6],
            control_no: row[7],
            measurement_accuracy: row[8],
            reference_document_no: row[9],
            calibration_in_house_external: row[10],
            laboratory_environmental_conditions: row[11],
            external_calibration_laboratory: row[12],
            remarks: row[13]
          }
          
          equipment.assign_attributes(attributes)
          equipment.save
          equipment_count += 1
          logger.info "Measurementequipmentデータを作成しました: #{equipment.control_no}" if equipment_count % BATCH_SIZE == 0
        rescue => e
          logger.error "Measurementequipmentデータの作成に失敗しました: #{e.message}"
        end
      end
    end
    GC.start
    sleep(0.1)
  end

  # Supplier データの作成と更新
  logger.info "--- Supplierデータの作成を開始します ---"
  supplier_count = 0
  CSV.foreach(Rails.root.join('db/record/suppliers.csv'), headers: true).each_slice(BATCH_SIZE) do |batch_rows|
    ActiveRecord::Base.transaction do
      batch_rows.each do |row|
        begin
          supplier = Supplier.new
          
          supplier_attributes = %w[
            no supplier_name manufacturer_name iso_existence target qms
            second_party_audit supplier_development automotive_related departments
            transaction_details address1 address2 postal_code tel fax
            filename document_name issue_date feedback_date
          ]
          
          supplier_attributes.each do |attr|
            supplier.send("#{attr}=", row[attr])
          end
          
          supplier.save
          supplier_count += 1
          
          if row['filename'].present? && row['document_name'].present?
            filenames = row['filename'].split(',').map(&:strip)
            document_names = row['document_name'].split(',').map(&:strip)

            filenames.zip(document_names).each do |filename, document_name|
              file_path = Rails.root.join("db/documents/#{filename}")
              if File.file?(file_path)
                begin
                  file_content = File.binread(file_path)
                  blob = ActiveStorage::Blob.create_and_upload!(
                    io: StringIO.new(file_content),
                    filename: filename
                  )
                  supplier.documents.attach(blob)
                  supplier.document_name = document_name
                rescue => e
                  logger.error "Supplierファイルの添付に失敗しました: #{file_path}、エラー: #{e.message}"
                end
              end
            end
          end
          
          supplier.save
          logger.info "Supplierデータを作成しました: #{supplier.no}" if supplier_count % BATCH_SIZE == 0
        rescue => e
          logger.error "Supplierデータの作成に失敗しました: #{e.message}"
        end
      end
    end
    GC.start
    sleep(0.1)
  end

  # Iatf データの作成
  logger.info "--- Iatfデータの作成を開始します ---"
  iatf_count = 0
  CSV.foreach('db/record/iatf_request_list.csv').each_slice(BATCH_SIZE) do |batch_rows|
    ActiveRecord::Base.transaction do
      batch_rows.each do |row|
        begin
          iatf = Iatf.create(
            no: row[0],
            name: row[1],
            sales: row[2],
            process_design: row[3],
            production: row[4],
            inspection: row[5],
            release: row[6],
            procurement: row[7],
            equipment: row[8],
            measurement: row[9],
            policy: row[10],
            satisfaction: row[11],
            audit: row[12],
            corrective_action: row[13]
          )
          iatf_count += 1
          logger.info "Iatfデータを作成しました: #{iatf.no}" if iatf_count % BATCH_SIZE == 0
        rescue => e
          logger.error "Iatfデータの作成に失敗しました: #{e.message}"
        end
      end
    end
    GC.start
    sleep(0.1)
  end

  # その他のデータ作成
  logger.info "--- その他のデータ作成を開始します ---"
  
  # CSR データ
  csr_count = 0
  CSV.foreach('db/record/mek_csr_list.csv').each_slice(BATCH_SIZE) do |batch_rows|
    ActiveRecord::Base.transaction do
      batch_rows.each do |row|
        begin
          csr = Csr.create(csr_number: row[0], csr_content: row[1])
          csr_count += 1
          logger.info "CSRデータを作成しました: #{csr.csr_number}" if csr_count % BATCH_SIZE == 0
        rescue => e
          logger.error "CSRデータの作成に失敗しました: #{e.message}"
        end
      end
    end
    GC.start
    sleep(0.1)
  end

  # Mitsui データ
  mitsui_count = 0
  CSV.foreach('db/record/mitsui_kajyou_list.csv').each_slice(BATCH_SIZE) do |batch_rows|
    ActiveRecord::Base.transaction do
      batch_rows.each do |row|
        begin
          mitsui = Mitsui.create(mitsui_number: row[0], mitsui_content: row[1])
          mitsui_count += 1
          logger.info "Mitsuiデータを作成しました: #{mitsui.mitsui_number}" if mitsui_count % BATCH_SIZE == 0
        rescue => e
          logger.error "Mitsuiデータの作成に失敗しました: #{e.message}"
        end
      end
    end
    GC.start
    sleep(0.1)
  end

  # Iatflist データ
  iatflist_count = 0
  CSV.foreach('db/record/iatf_kajyou_list.csv').each_slice(BATCH_SIZE) do |batch_rows|
    ActiveRecord::Base.transaction do
      batch_rows.each do |row|
        begin
          iatflist = Iatflist.create(iatf_number: row[0], iatf_content: row[1])
          iatflist_count += 1
          logger.info "Iatflistデータを作成しました: #{iatflist.iatf_number}" if iatflist_count % BATCH_SIZE == 0
        rescue => e
          logger.error "Iatflistデータの作成に失敗しました: #{e.message}"
        end
      end
    end
    GC.start
    sleep(0.1)
  end

  # テスト問題データの作成
  logger.info "--- テスト問題データの作成を開始します ---"
  mondai_count = 0
  Dir.glob('db/record/bing/kajyou*.csv').each do |file|
    CSV.foreach(file).each_slice(BATCH_SIZE) do |batch_rows|
      ActiveRecord::Base.transaction do
        batch_rows.each do |row|
          begin
            mondai = Testmondai.create(
              kajyou: row[0],
              mondai_no: row[1],
              rev: row[2],
              mondai: row[3],
              mondai_a: row[4],
              mondai_b: row[5],
              mondai_c: row[6],
              seikai: row[7],
              kaisetsu: row[8]
            )
            mondai_count += 1
            logger.info "テスト問題データを作成しました: #{mondai.mondai_no}" if mondai_count % BATCH_SIZE == 0
          rescue => e
            logger.error "テスト問題データの作成に失敗しました: #{e.message}"
          end
        end
      end
      GC.start
      sleep(0.1)
    end
  end

  total_time = Time.current - start_time
  logger.info "=== すべてのシードデータの作成が完了しました ==="
  logger.info "総処理時間: #{total_time}秒"

rescue => e
  logger.error "シードデータの作成中にエラーが発生しました: #{e.message}"
  logger.error e.backtrace.join("\n")
ensure
  logger.info "=== シードデータの作成を終了します ==="
  logger.close if logger
end