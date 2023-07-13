require "csv"

#active storage使用時のseedファイル作成方法（ruby on rails）
#https://qiita.com/taiki-nd/items/1dd37d6093b3f0f659ad

CSV.foreach(Rails.root.join("db/record/attachedfile.csv"), headers: true) do |row|
  product = Product.new
  product.category = row["category"]
  product.partnumber = row["partnumber"]
  product.materialcode = row["materialcode"]
  product.phase = row["phase"]
  product.stage = row["stage"]
  product.description = row["description"]
  product.status = row["status"]
  product.documenttype = row["documenttype"]
  product.documentname = row["documentname"]
  product.documentrev = row["documentrev"]
  product.documentcategory = row["documentcategory"]
  product.documentnumber = row["documentnumber"]
  product.start_time = row["start_time"]
  product.deadline_at = row["deadline_at"]
  product.end_at = row["end_at"]
  product.goal_attainment_level = row["goal_attainment_level"]
  product.tasseido = row["tasseido"]
  product.object = row["object"]
  
  if row["filename"].present?
    file_path = Rails.root.join("db/documents/#{row["filename"]}")
    if File.file?(file_path)
      product.documents = ActiveStorage::Blob.create_and_upload!(io: File.open(file_path), filename: row["filename"])
    else
      puts "File not found: #{file_path}"
    end
  else
    puts "Filename is empty"
  end
  
  product.save
end

CSV.foreach('db/category.csv') do |row|
  Phase.create(:id => row[0], :name => row[1], :ancestry => row[2])
  
end

CSV.foreach('db/record/login.csv') do |row|
  User.create(:id => row[0], :email => row[1], :password => row[2], :name => row[3], :role => row[4],:owner => row[5],:auditor => row[6])
end


#CSV.foreach('db/record/suppliers.csv') do |row|
#  Supplier.create(:no => row[0],:supplier_name => row[1], :manufacturer_name => row[2], :iso_existence => row[3], :target => row[4], :qms => row[5],:second_party_audit => row[6],:supplier_development => row[7],:automotive_related => row[8],:departments  => row[9],:transaction_details => row[10],:address1 => row[11],:address2 => row[12],:postal_code => row[13],:tel => row[14],:fax => row[15])
#end

CSV.foreach(Rails.root.join("db/record/suppliers.csv"), headers: true) do |row|
  supplier = Supplier.create(:no => row[0], :supplier_name => row[1], :manufacturer_name => row[2], :iso_existence => row[3], :target => row[4], :qms => row[5], :second_party_audit => row[6], :supplier_development => row[7], :automotive_related => row[8], :departments  => row[9], :transaction_details => row[10], :address1 => row[11], :address2 => row[12], :postal_code => row[13], :tel => row[14], :fax => row[15], :filename => row[16], :document_name => row[17], :issue_date => row[18], :feedback_date => row[19])

  if row["filename"].present? && row["document_name"].present?
    # Split the filenames and document_names by comma and remove any leading/trailing white space
    filenames = row["filename"].split(',').map(&:strip)
    document_names = row["document_name"].split(',').map(&:strip)

    # Create and attach a blob for each filename
filenames.zip(document_names).each do |filename, document_name|
  file_path = Rails.root.join("db/documents/#{filename}")
  if File.file?(file_path)
    blob = ActiveStorage::Blob.create_and_upload!(io: File.open(file_path), filename: filename)
    supplier.documents.attach(blob)
    supplier.document_name = document_name  # Update the supplier's document_name
  else
    puts "File not found: #{file_path}"
  end
end
  else
    puts "Filename and/or Document Name is empty"
  end
  
  supplier.save
end




CSV.foreach('db/record/iatf_request_list.csv') do |row|
  Iatf.create(:no => row[0],:name => row[1], :sales => row[2], :process_design => row[3], :production => row[4], :inspection => row[5],:release => row[6],:procurement => row[7],:equipment => row[8],:measurement => row[9],:policy => row[10],:satisfaction => row[11],:audit => row[12],:corrective_action => row[13])
end



CSV.foreach('db/record/mek_csr_list.csv') do |row|
  Csr.create(:csr_number => row[0],:csr_content => row[1])
end

CSV.foreach('db/record/iatf_kajyou_list.csv') do |row|
  Iatflist.create(:iatf_number => row[0],:iatf_content => row[1])
end

Dir.glob('db/record/bing/kajyou*.csv') do |file|
  CSV.foreach(file) do |row|
    Testmondai.create(
      :kajyou    => row[0],
      :mondai_no => row[1],
      :rev       => row[2],
      :mondai    => row[3],
      :mondai_a  => row[4],
      :mondai_b  => row[5],
      :mondai_c  => row[6],
      :seikai    => row[7],
      :kaisetsu  => row[8]
    )
  end
end


#rails c でカラムの確認
#https://qiita.com/littlekbt/items/48fa2b428147921db5a5

#CSV.foreach('db/record/test_mondai.csv') do |row|
#  Testmondai.create(
#  :kajyou    => row[0], 
#  :mondai_no => row[1], 
#  :rev       => row[2],
#  :mondai    => row[3],
#  :mondai_a  => row[4],
#  :mondai_b  => row[5],
#  :mondai_c  => row[6],
#  :seikai    => row[7],
#  :kaisetsu  => row[8]
#  
#  )
#end

#下記では、モデルにCSVのデータを流し込めなかった。。。
#CSV.foreach('db/record/test_mondai.csv',headers: true) do |row|
#  Testmondai.create(
#  kajyou:    row['kajyou'], 
#  mondai_no: row['mondai_no'],
#  rev:       row['rev'],
#  mondai:    row['mondai'],
#  mondai_a:  row['mondai_a'], 
#  mondai_b:  row['mondai_b'], 
#  mondai_c:  row['mondai_c'],
#  seikai:    row['seikai'], 
#  kaisetsu:  row['kaisetsu']
#  )
#end


