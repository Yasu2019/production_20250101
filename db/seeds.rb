# frozen_string_literal: true

require 'csv'

# グローバル変数を使用してカウンターを管理
$row_count = 0
$error_count = 0

# ファイル添付用のヘルパーメソッド
def attach_file(record, file_path, filename)
  return unless File.file?(file_path)
  
  File.open(file_path) do |file|
    begin
      record.documents.attach(io: file, filename: filename)
    rescue => e
      puts "ファイルの添付に失敗しました: #{file_path}、エラー: #{e.message}"
    end
  end
end

# メインの製品データ処理
ActiveRecord::Base.transaction do
  CSV.foreach(Rails.root.join('db/record/attachedfile.csv'), headers: true) do |row|
    $row_count += 1
    begin
      product = Product.find_or_initialize_by(documentnumber: row['documentnumber']&.strip)
      
      # 基本属性の設定
      attributes = %w[
        category partnumber materialcode phase stage description status
        documenttype documentname documentrev documentcategory start_time
        deadline_at end_at goal_attainment_level tasseido object
      ]
      
      attributes.each do |attr|
        product.send("#{attr}=", row[attr])
      end

      # ファイル添付処理
      if row['filename'].present?
        file_path = Rails.root.join("db/documents/#{row['filename']}")
        attach_file(product, file_path, row['filename'])
      end

      unless product.save
        $error_count += 1
        puts "行 #{$row_count}: 製品の保存に失敗しました。ドキュメント番号: #{product.documentnumber}。" \
             "エラー: #{product.errors.full_messages.join(', ')}"
      end
    rescue => e
      $error_count += 1
      puts "行 #{$row_count}: エラーが発生しました: #{e.message}"
    end
  end

  puts "処理完了。合計 #{$row_count} 行を処理しました。エラー数: #{$error_count}"
end

# Phase データの更新
CSV.foreach('db/category.csv') do |row|
  phase = Phase.find_or_initialize_by(id: row[0])
  phase.update(name: row[1], ancestry: row[2])
end

# User データの更新
CSV.foreach('db/record/login.csv') do |row|
  user = User.find_or_initialize_by(id: row[0])
  user.update(
    email: row[1],
    password: row[2],
    name: row[3],
    role: row[4],
    owner: row[5],
    auditor: row[6]
  )
end

# Measurementequipment データの作成
CSV.foreach('db/record/measurement_equipment.csv') do |row|
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
end

# Supplier データの作成と更新
CSV.foreach(Rails.root.join('db/record/suppliers.csv'), headers: true) do |row|
  supplier = Supplier.new
  
  # 基本属性の設定
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
  
  # ファイル添付処理
  if row['filename'].present? && row['document_name'].present?
    filenames = row['filename'].split(',').map(&:strip)
    document_names = row['document_name'].split(',').map(&:strip)

    filenames.zip(document_names).each do |filename, document_name|
      file_path = Rails.root.join("db/documents/#{filename}")
      if File.file?(file_path)
        File.open(file_path) do |file|
          blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename)
          supplier.documents.attach(blob)
          supplier.document_name = document_name
        end
      else
        Rails.logger.info "ファイルが見つかりません: #{file_path}"
      end
    end
  end
  
  supplier.save
end

# Iatf データの作成
CSV.foreach('db/record/iatf_request_list.csv') do |row|
  Iatf.create(
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
end

# その他のデータ作成
CSV.foreach('db/record/mek_csr_list.csv') do |row|
  Csr.create(csr_number: row[0], csr_content: row[1])
end

CSV.foreach('db/record/mitsui_kajyou_list.csv') do |row|
  Mitsui.create(mitsui_number: row[0], mitsui_content: row[1])
end

CSV.foreach('db/record/iatf_kajyou_list.csv') do |row|
  Iatflist.create(iatf_number: row[0], iatf_content: row[1])
end

# テスト問題データの作成
Dir.glob('db/record/bing/kajyou*.csv') do |file|
  CSV.foreach(file) do |row|
    Testmondai.create(
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
  end
end