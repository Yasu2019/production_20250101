
#下記Requireがないと、rubyXLが動かない
#revise 
require 'roo'
require 'rubyXL/convenience_methods'
require 'rubyXL/convenience_methods/worksheet'
require 'rubyXL/convenience_methods/cell'
require 'csv'

class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :phase, only: %i[ process_design_plan_report graph calendar new edit show index index2 index3 index8 index9 download xlsx generate_xlsx]




  include ExcelTemplateHelper

  #Railsで既存のエクセルファイルをテンプレートにできる魔法のヘルパー
  #https://qiita.com/m-kubo/items/6b5beaaf2a59c0d75bcc#:~:text=Rails%E3%81%A7%E6%97%A2%E5%AD%98%E3%81%AE%E3%82%A8%E3%82%AF%E3%82%BB%E3%83%AB%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92%E3%83%86%E3%83%B3%E3%83%97%E3%83%AC%E3%83%BC%E3%83%88%E3%81%AB%E3%81%A7%E3%81%8D%E3%82%8B%E9%AD%94%E6%B3%95%E3%81%AE%E3%83%98%E3%83%AB%E3%83%91%E3%83%BC%201%20%E3%81%AF%E3%81%98%E3%82%81%E3%81%AB%20%E4%BB%8A%E5%9B%9E%E3%81%AE%E3%82%B3%E3%83%BC%E3%83%89%E3%81%AF%E3%80%81%E4%BB%A5%E4%B8%8B%E3%81%AE%E7%92%B0%E5%A2%83%E3%81%A7%E5%8B%95%E4%BD%9C%E7%A2%BA%E8%AA%8D%E3%81%97%E3%81%A6%E3%81%84%E3%81%BE%E3%81%99%E3%80%82%20...%202%201.%20rubyXL,7%206.%20%E3%81%8A%E3%81%BE%E3%81%91%20...%208%20%E7%B5%82%E3%82%8F%E3%82%8A%E3%81%AB%20%E4%BB%A5%E4%B8%8A%E3%80%81%E3%81%A9%E3%81%93%E3%81%8B%E3%81%AE%E6%A1%88%E4%BB%B6%E3%81%A7%E6%9B%B8%E3%81%84%E3%81%9F%E3%82%B3%E3%83%BC%E3%83%89%E3%81%AE%E7%B4%B9%E4%BB%8B%E3%81%A7%E3%81%97%E3%81%9F%E3%80%82%20



  def process_design_plan_report
    @products = Product.where(partnumber:params[:partnumber])           #link_to用
    @all_products = Product.all
    puts "params: #{params.inspect}"  # 追加
    #@products = Product.where(partnumber: params[:product][:partnumber]) #form_to用
 
    create_data
    send_data(
      excel_render('lib/excel_templates/process_design_plan_report.xlsx').stream.string,
      type: 'application/vnd.ms-excel',
      filename: "#{@datetime.strftime("%Y%m%d")}_#{@partnumber}_製造工程設計計画／実績書.xlsx"
    )


  end

  #kここにあった
  



  def iot

     #【Rails】Time.currentとTime.nowの違い
    #https://qiita.com/kodai_0122/items/111457104f83f1fb2259

    timetoday=Time.current.strftime("%Y_%m_%d")

    
    #CSVで取り込んだデータを綺麗なグラフで表示する
    #https://toranoana-lab.hatenablog.com/entry/2018/11/27/182518

    #ファイルやディレクトリが存在するか調べる (File.exist?, Dir.exist?)
    #https://maku77.github.io/ruby/io/file-exist.html
    data = []
    data_temp = []
    if File.file?('/myapp/db/record/'+timetoday+'SHT31Temp.csv')
        CSV.foreach('/myapp/db/record/'+timetoday+'SHT31Temp.csv', headers: true) do |row|
          data=[row[0],row[1]]
          data_temp.push(data)
        end
        @temp = data_temp
    end


    data = []
    data_humi = []
    if File.file?('/myapp/db/record/'+timetoday+'SHT31Humi.csv')
        CSV.foreach('/myapp/db/record/'+timetoday+'SHT31Humi.csv', headers: true) do |row|
          data=[row[0],row[1]]
          data_humi.push(data)
        end
        @humi = data_humi
    end

    #----- Komatsu25トン3号機

    data = []
    data_komatsu25t3_shot = []
    if File.file?('/myapp/db/record/'+timetoday+'ShotKomatsu25t3.csv')
        CSV.foreach('/myapp/db/record/'+timetoday+'ShotKomatsu25t3.csv', headers: true) do |row|
          data=[row[0],row[1]]
          data_komatsu25t3_shot.push(data)
        end
        @komatsu25t3_shot = data_komatsu25t3_shot
    end

    data = []
    data_komatsu25t3_spm = []
    if File.file?('/myapp/db/record/'+timetoday+'SPMKomatsu25t3.csv')
        CSV.foreach('/myapp/db/record/'+timetoday+'SPMKomatsu25t3.csv', headers: true) do |row|
          data=[row[0],row[1]]
          data_komatsu25t3_spm.push(data)
        end
        @komatsu25t3_spm = data_komatsu25t3_spm
    end

    data = []
    data_komatsu25t3_chokotei = []
    if File.file?('/myapp/db/record/'+timetoday+'StampingchokoteiKomatsu25t3.csv')
        CSV.foreach('/myapp/db/record/'+timetoday+'StampingchokoteiKomatsu25t3.csv', headers: true) do |row|
          data=[row[0],row[1]]
          data_komatsu25t3_chokotei.push(data)
        end
        @komatsu25t3_chokotei = data_komatsu25t3_chokotei
    end

    data = []
    data_komatsu25t3_jyotai = []
    if File.file?('/myapp/db/record/'+timetoday+'JYOTAIKomatsu25t3.csv')
        CSV.foreach('/myapp/db/record/'+timetoday+'JYOTAIKomatsu25t3.csv', headers: true) do |row|
          data=[row[0],row[1]]
          data_komatsu25t3_jyotai.push(data)
        end
        @komatsu25t3_jyotai = data_komatsu25t3_jyotai
    end

    #----- Dobby3トン4号機

    data = []
    data_chokoteiDobby30t4 = []
    if File.file?('/myapp/db/record/'+timetoday+'chokoteiDobby30t4.csv')
        CSV.foreach('/myapp/db/record/'+timetoday+'chokoteiDobby30t4.csv', headers: true) do |row|
          data=[row[0],row[1]]
          data_chokoteiDobby30t4.push(data)
        end
        @chokoteiDobby30t4 = data_chokoteiDobby30t4
    end

    data = []
    data_JYOTAIDobby30t4 = []
    if File.file?('/myapp/db/record/'+timetoday+'JYOTAIDobby30t4.csv')
        CSV.foreach('/myapp/db/record/'+timetoday+'JYOTAIDobby30t4.csv', headers: true) do |row|
          data=[row[0],row[1]]
          data_JYOTAIDobby30t4.push(data)
        end
        @JYOTAIDobby30t4 = data_JYOTAIDobby30t4
    end

    #----- Amada80トン3号機

    data = []
    data_StampingJYOTAIAmada80t3 = []
    if File.file?('/myapp/db/record/'+timetoday+'StampingJYOTAIAmada80t3.csv')
        CSV.foreach('/myapp/db/record/'+timetoday+'StampingJYOTAIAmada80t3.csv', headers: true) do |row|
          data=[row[0],row[1]]
          data_StampingJYOTAIAmada80t3.push(data)
        end
        @StampingJYOTAIAmada80t3 = data_StampingJYOTAIAmada80t3
    end

    data = []
    data_StampingchokoteiAmada80t3 = []
    if File.file?('/myapp/db/record/'+timetoday+'StampingchokoteiAmada80t3.csv')
        CSV.foreach('/myapp/db/record/'+timetoday+'StampingchokoteiAmada80t3.csv', headers: true) do |row|
          data=[row[0],row[1]]
          data_StampingchokoteiAmada80t3.push(data)
        end
        @StampingchokoteiAmada80t3 = data_StampingchokoteiAmada80t3
    end

    data = []
    data_SPMAmada80t3 = []
    if File.file?('/myapp/db/record/'+timetoday+'SPMAmada80t3.csv')
        CSV.foreach('/myapp/db/record/'+timetoday+'SPMAmada80t3.csv', headers: true) do |row|
          data=[row[0],row[1]]
          data_SPMAmada80t3.push(data)
        end
        @SPMAmada80t3 = data_SPMAmada80t3
    end

    data = []
    data_ShotAmada80t3 = []
    if File.file?('/myapp/db/record/'+timetoday+'ShotAmada80t3.csv')
        CSV.foreach('/myapp/db/record/'+timetoday+'ShotAmada80t3.csv', headers: true) do |row|
          data=[row[0],row[1]]
          data_ShotAmada80t3.push(data)
        end
        @ShotAmada80t3 = data_ShotAmada80t3
    end



    #timetoday=Time.now.strftime("%Y_%m_%d")
    #file = Dir.glob("C:/Users/mec21/20230213_iot_csv_training_tailwind_daisyui_ancestry_importmap/db/record/"+timetoday+"SHT31Humi.csv")
    #file = Dir.glob("/myapp/db/record/2023_02_18SHT31Temp.csv")
    #IOTデータページ

    #@iots=Iot.all 
  end

  def import
    # fileはtmpに自動で一時保存される
    Product.import(params[:file])
    redirect_to products_url
  end

  #def iot_import
    # fileはtmpに自動で一時保存される

    #【Rails】ファイルのフルパス、ファイル名を取得する
    #https://opiyotan.hatenablog.com/entry/rails-glob

    #time=Time.now.strftime("%Y_%m_%d")

    #file = Dir.glob("C:/Users/mec21/20230213_iot_csv_training_tailwind_daisyui_ancestry_importmap/db/record/test.csv")

    #file = params[:file]

    #datas = []
    #unless file.nil?
    #  ActiveRecord::Base.transaction do
    #    CSV.foreach(file.path, headers: true) do |row|
    #      datas.append(Hash[row])
    #    end
    #  end
    #end
    #@chartkickgraph = {"1": 1000,"3": 20000,"5": 1500,"7": 18000}
    #@chartkickgraph = datas[0]

    #redirect_to products_url
  #end

  #RailsでAxlsxを使ってxlsxを生成
  #https://qiita.com/necojackarc/items/0dbd672b2888c30c5a38

  def xlsx
    @products = Product.all
    respond_to do |format|
      format.html
      format.xlsx do
        generate_xlsx
      end
    end
  end

  def search
    @qd = Product.ransack(params[:qd])
    #@products = @qd.result
    @products = @qd.result(distinct: true)
    #@user = current_user
    #binding.pry
  end

  def graph
    #@products=Product.all.page(params[:page]).per(10)
    @products=Product.all
    #@user = current_user    
  end

  def calendar
    #@products=Product.all.page(params[:page]).per(10)
    @products=Product.all
    #@user = current_user    
  end

  def training
    #@products=Product.all.page(params[:page]).per(10)
    @products=Product.all

    #@user = current_user
  end


  def new
    @product = Product.new
  end

  def index
    #@products = Product.all
    #@products = Product.page(params[:page]).per(8)
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true)
    @user = current_user
    @testmondais = Testmondai.all


    #data = []
    #data_test = []
    #if File.file?('/myapp/db/record/test_mondai.csv')
    #    CSV.foreach('/myapp/db/record/test_mondai.csv', headers: true) do |row|
    #      data=[row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8]]
    #      data_test.push(data)
    #    end
    #    @test_mondai = data_test
    #end


    #@test_mondais=Test_mondai

  end

  def index2
    @products = Product.where(partnumber:params[:partnumber])
  end

  def index3
    #こちらを選択していた@products=Product.select("DISTINCT ON (partnumber,food) *").page(params[:page]).per(4)
    @products=Product.select("DISTINCT ON (partnumber,stage) *")

    @mark_complate="完"
    @mark_WIP="仕掛"

    #@user = current_user
  end

  def index4
  #IATF要求事項説明ページ
  end

  def index8
    @products = Product.where(partnumber:params[:partnumber])
  end

  def index9
    @products=Product.select("DISTINCT ON (partnumber,stage) *")

    #@user = current_user
  end

  #RailsでExcel出力しないといけなくなった時の対処法
  #https://www.timedia.co.jp/tech/railsexcel/

  def download
    response.headers["Content-Type"] = "application/excel"
    response.headers["Content-Disposition"] = "attachment; filename=\"製品データ.xls\""
      #@date_from = Date.new(2014,3,1)
      #@date_to = Date.new(2014,3,31)
      #@product = Product.find(params[:id])
    @products=Product.all

      #@stocks = ProductStock
      #  .where(product_id: @product.id)
      #  .where(date: @date_from..@date_to)
      #  .order(:date)
    render 'data_download.xls.erb'

  end

  #RailsでExcel出力しないといけなくなった時の対処法
  #https://www.timedia.co.jp/tech/railsexcel/
  #def process_design_download
  #  response.headers["Content-Type"] = "application/excel"
  #  response.headers["Content-Disposition"] = "attachment; filename=\"製造工程設計計画書／実績書.xls\""
  #  @products = Product.where(partnumber:params[:partnumber])
  #  render 'process_design_download.xls.erb'
  #end

#  def process_design_download
#    response.headers["Content-Type"] = "application/excel"
#    response.headers["Content-Disposition"] = "attachment; filename=\"製造工程設計計画書／実績書.xls\""
#    @products = Product.where(partnumber: params[:partnumber])
#    render 'products/process_design_download', formats: [:xls]
#  end

def process_design_download
  require 'axlsx'
  template_path = Rails.root.join('app', 'views', 'products', 'process_design_download.xlsx').to_s
  # テンプレートファイルを読み込む
  template = Axlsx::Package.new
  workbook = template.workbook
  workbook = workbook.open(template_path)
  worksheet = workbook.worksheets.first

  @products = Product.where(partnumber: params[:partnumber])

  # データを挿入する行のインデックス
  start_row = 2

  # データを挿入する
  @products.each_with_index do |product, index|
    row = start_row + index
    worksheet.add_row [
      product.category,
      product.created_at,
      product.deadline_at,
      product.description,
      product.documentcategory,
      product.documentname,
      product.documentnumber,
      product.documentrev,
      product.documenttype,
      product.end_at,
      product.goal_attainment_level,
      product.id,
      product.materialcode,
      product.object,
      product.partnumber,
      product.phase,
      product.stage,
      product.start_time,
      product.status,
      product.tasseido,
      product.updated_at
    ], row_offset: row
  end

  # ダウンロード用の一時ファイルを作成
  temp_file = Tempfile.new('process_design_download.xlsx')

  # テンプレートを保存してダウンロードファイルを作成
  template.serialize(temp_file.path)

  # ダウンロードファイルを送信
  send_file temp_file.path, filename: "製造工程設計計画書／実績書.xlsx"

  # 一時ファイルを削除
  temp_file.close
  temp_file.unlink
end


  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: '登録しました。'
    else
    render :new
    end

  end

  def show
    #@product = Product.find(params[:id])
    if @product.documents.attached?
      @product.documents.each do |image|
        fullfilename = rails_blob_path(image)
        @ext = File.extname(fullfilename).downcase
        if @ext== ".jpg" ||  @ext== ".jpeg" ||  @ext== ".png" ||  @ext== ".gif"
          @Attachment_file = true
        else
          @Attachment_file = false
        end
      end
    end
  end


  def edit
      #@product = Product.find(params[:id])
      @title=Product.find(params[:id])
      if @product.documents.attached?
          @product.documents.each do |image|
            fullfilename = rails_blob_path(image)
            @ext = File.extname(fullfilename).downcase
            if @ext== ".jpg" ||  @ext== ".jpeg" ||  @ext== ".png" ||  @ext== ".gif"
              @Attachment_file = true
            else
              @Attachment_file = false
            end
          end
      end
  end

#  def update
#    #Rails7で画像の保存にActiveStorage使ってみよう(導入からリサイズまで)
#    #https://qiita.com/asasigure/items/311473d25fb3ec97f126
#
#    #ActiveStorage で画像を複数枚削除する方法
#    #https://h-piiice16.hatenablog.com/entry/2018/09/24/141510#
#
#    #Active Storageを使用して添付ファイル(アップロード)を簡単に管理する
#    #https://www.petitmonte.com/ruby/rails_attachment.html
#
#    #@product = Product.find(params[:id])
#    #@product.update params.require(:product).permit(:partnumber, documents: []) # POINT
#    #redirect_to @product
#
#
#    product = Product.find(params[:id])
#    #if params[:product][:detouch]=='1'
#    if params[:product][:detouch]
#       params[:product][:detouch].each do |image_id|
#       #image = product.files.find(image_id)
#        image = @product.documents.find(image_id)
#        image.purge
#       end
#    end
#   #【rails】update_attributes→updateを使う
#   #update_attributesはrails6.1から削除されたそうです。
#   #https://qiita.com/yuka_nari/items/b04c872d4eb2e5347fdb
#
#   if product.update(product_params)
#     flash[:success] = "編集しました"
#    redirect_to @product
#   else
#    render :edit
#   end
#  end



#ChatGPT修正版
def update
  @product = Product.find_by(id: params[:id])

  if @product.nil?
    flash[:error] = "Product not found"
    redirect_to root_path # Or wherever you want to redirect
    return
  end

  if params[:product][:detouch]
    params[:product][:detouch].each do |image_id|
      image = @product.documents.find(image_id)
      image.purge
    end
  end

  if params[:product][:documents]
    @product.documents.attach(params[:product][:documents])
  end

  if @product.update(product_params.except(:documents))
    flash[:success] = "編集しました"
    redirect_to @product
  else
    render :edit
  end
end


  

  def destroy
    #@product = Product.find(params[:id])
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  #Railsで既存のエクセルファイルをテンプレートにできる魔法のヘルパー
  #https://qiita.com/m-kubo/items/6b5beaaf2a59c0d75bcc#:~:text=Rails%E3%81%A7%E6%97%A2%E5%AD%98%E3%81%AE%E3%82%A8%E3%82%AF%E3%82%BB%E3%83%AB%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92%E3%83%86%E3%83%B3%E3%83%97%E3%83%AC%E3%83%BC%E3%83%88%E3%81%AB%E3%81%A7%E3%81%8D%E3%82%8B%E9%AD%94%E6%B3%95%E3%81%AE%E3%83%98%E3%83%AB%E3%83%91%E3%83%BC%201%20%E3%81%AF%E3%81%98%E3%82%81%E3%81%AB%20%E4%BB%8A%E5%9B%9E%E3%81%AE%E3%82%B3%E3%83%BC%E3%83%89%E3%81%AF%E3%80%81%E4%BB%A5%E4%B8%8B%E3%81%AE%E7%92%B0%E5%A2%83%E3%81%A7%E5%8B%95%E4%BD%9C%E7%A2%BA%E8%AA%8D%E3%81%97%E3%81%A6%E3%81%84%E3%81%BE%E3%81%99%E3%80%82%20...%202%201.%20rubyXL,7%206.%20%E3%81%8A%E3%81%BE%E3%81%91%20...%208%20%E7%B5%82%E3%82%8F%E3%82%8A%E3%81%AB%20%E4%BB%A5%E4%B8%8A%E3%80%81%E3%81%A9%E3%81%93%E3%81%8B%E3%81%AE%E6%A1%88%E4%BB%B6%E3%81%A7%E6%9B%B8%E3%81%84%E3%81%9F%E3%82%B3%E3%83%BC%E3%83%89%E3%81%AE%E7%B4%B9%E4%BB%8B%E3%81%A7%E3%81%97%E3%81%9F%E3%80%82%20
  def create_data
    @datetime = Time.now
    @name = 'm-kubo'
    @multi_lines_text = "Remember kids,\nthe magic is with in you.\nI'm princess m-kubo."
    @cp_check="☐"
    @datou_check="☐"
    @scr_check="☐"
    @pfmea_check="☐"
    @dr_check="☐"
    @msa_check="☐"
    @msa_crosstab_check="☐"
    @msa_grr_check="☐"
    @cpk_check="☐"
    @shisaku_check="☐"
    @kanagata_check="☐"
    @dr_setsubi_check="☐"
    @grr_check="☐"
    @feasibility_check="☐"
    @kataken_check="☐"
  

    @products.each do |pro|
      @partnumber=pro.partnumber
      Rails.logger.info "@partnumber= #{@partnumber}"  # 追加
      @materialcode=pro.materialcode
      Rails.logger.info "@pro.stage= #{@dropdownlist[pro.stage.to_i]}"
      stage=@dropdownlist[pro.stage.to_i]
      Rails.logger.info "pro.stage(number)= #{pro.stage}"
 
      if stage=="量産コントロールプラン" || stage=="試作コントロールプラン"
        @controlplan_yotei=pro.deadline_at.strftime('%y/%m/%d')
        @controlplan_kanryou=pro.end_at.strftime('%y/%m/%d')
        if pro.documents.attached?
          @cp_check="☑"
        else
          @cp_check="☐"
        end
      end

      if stage=="妥当性確認記録_金型設計"
        @datou_yotei=pro.deadline_at.strftime('%y/%m/%d')
        @datou_kanryou=pro.end_at.strftime('%y/%m/%d')
        if pro.documents.attached?
          @datou_check="☑"
        else
          @datou_check="☐"
        end
      end

      if stage=="顧客要求事項検討会議事録_営業"
        @scr_yotei=pro.deadline_at.strftime('%y/%m/%d')
        @scr_kanryou=pro.end_at.strftime('%y/%m/%d')
        if pro.documents.attached?
          @scr_check="☑"
        else
          @scr_check="☐"
        end
      end

      if stage=="製造実現可能性検討書"
        @scr_yotei=pro.deadline_at.strftime('%y/%m/%d')
        @scr_kanryou=pro.end_at.strftime('%y/%m/%d')
        if pro.documents.attached?
          @feasibility_check="☑"
        else
          @feasibility_check="☐"
        end
      end

      if stage=="プロセスFMEA"
        @pfmea_yotei=pro.deadline_at.strftime('%y/%m/%d')
        @pfmea_kanryou=pro.end_at.strftime('%y/%m/%d')
        if pro.documents.attached?
          @pfmea_check="☑"
        else
          @pfmea_check="☐"
        end
      end

      if stage=="DR会議議事録_金型設計"
        @dr_yotei=pro.deadline_at.strftime('%y/%m/%d')
        @dr_kanryou=pro.end_at.strftime('%y/%m/%d')
        if pro.documents.attached?
          # 変数の設定
          partnumber = pro.partnumber  # ここには実際の値を設定してください
          # パスとファイル名のパターンを作成
          pattern = "/myapp/db/documents/*#{partnumber}*D.R会議議事録*"
          Rails.logger.info "Path= #{pattern}"
          # パターンに一致するファイルを取得
          files = Dir.glob(pattern)
          # 各ファイルに対して処理を行う
          files.each do |file|
            # Excelファイルを開く
            if File.extname(file) == '.xlsx'
              workbook = Roo::Excelx.new(file) #xlsxの場合はこちらを使用
            elsif File.extname(file) == '.xls'
              workbook = Roo::Excel.new(file) #xlsの場合はこちらを使用
            end

            # 最初のシートを取得
            worksheet = workbook.sheet(0)

            # i4のセルの値を取得
            
            #@dr_kanagata_shiteki = worksheet.cell(12, 1).nil? ? "" : worksheet.cell(12, 1).to_s + worksheet.cell(13, 1).to_s
            @dr_kanagata_shiteki = (12..28).map { |row| worksheet.cell(row, 1)&.to_s}.compact.join("\n")
          end

          @dr_check="☑"
        else
          @dr_check="☐"
        end
      end

      if stage == "測定システム解析（MSA)" # クロスタブ
        @msa_yotei = pro.deadline_at.strftime('%y/%m/%d')
        @msa_kanryou = pro.end_at.strftime('%y/%m/%d')
      
        if pro.documents.attached?
          # 変数の設定
          partnumber = pro.partnumber
          pattern = "/myapp/db/documents/*#{partnumber}*計数値MSA報告書*"
          Rails.logger.info "Path= #{pattern}"
          files = Dir.glob(pattern)
          @msa_crosstab_count = files.size
      
          # 各記号のカウントを初期化
          @maru_count = 0
          @batsu_count = 0
          @sankaku_count = 0
          @oomaru_count = 0
      
          files.each do |file|
            workbook = Roo::Excelx.new(file)
            worksheet = workbook.sheet(0)
      
            if worksheet.cell(4, 24) != nil
              @msa_kanryou = worksheet.cell(4, 24)
              @msa_recorder= worksheet.cell(6, 24)
              @msa_person = worksheet.cell(76, 29)
              @msa_approved = worksheet.cell(76, 25)
            end
      
            symbols = [worksheet.cell(131, 7), worksheet.cell(131, 11), worksheet.cell(131, 15)]
      
            # 各ファイルのカウントを累計
            @maru_count += symbols.count("○")
            @batsu_count += symbols.count("×")
            @sankaku_count += symbols.count("△")
            @oomaru_count += symbols.count("◎")
          end
      
          @msa_crosstab_check = "☑"
        else
          @msa_crosstab_check = "☐"
          @msa_crosstab_count = 0
        end
      end
      
      

      if stage == "寸法測定結果" # 型検
        @kataken_yotei = pro.deadline_at.strftime('%y/%m/%d')
        @kataken_kanryou = pro.end_at.strftime('%y/%m/%d')
        
        if pro.documents.attached?
          # 変数の設定
          partnumber = pro.partnumber
          pattern = "/myapp/db/documents/*#{partnumber}*検定報告書*"
          Rails.logger.info "Path= #{pattern}"
          
          files = Dir.glob(pattern)
          files.each do |file|
            if File.extname(file) == '.xlsx'
              workbook = Roo::Excelx.new(file)
            elsif File.extname(file) == '.xls'
              workbook = Roo::Excel.new(file)
            end
      
            worksheet = workbook.sheet("データ")
            @kataken_person_in_charge = worksheet.cell(50, 71)
            @cpk_manager = worksheet.cell(50, 76)
      
            if worksheet.cell(3, 28) != nil
              @kataken_kanryou = worksheet.cell(3,28)
            end

            @kataken_cpk_OK = 0
@kataken_cpk_NG = 0
(1..200).each do |row|
  if worksheet.cell(row, 2) == "Cpk"  # B列はインデックス2
    (3..30).each do |col|  # C列からAD列はインデックス3から30
      raw_value = worksheet.cell(row, col)
      if raw_value.is_a?(Numeric)  # 数値の場合のみ処理を行う
        value = raw_value.to_f
        if value >= 1.67
          @kataken_cpk_OK += 1
        else
          @kataken_cpk_NG += 1
        end
      end
    end
  end
end
            
@kataken_spec_OK = 0
@kataken_spec_NG = 0
(1..200).each do |row|
  if worksheet.cell(row, 2) == "Spec"  # B列はインデックス2
    (3..30).each do |col|  # C列からAD列はインデックス3から30
      value = worksheet.cell(row, col)
      if value == "OK"
        @kataken_spec_OK += 1
      elsif value == "NG"
        @kataken_spec_NG += 1
      end
    end
  end
end



            @kataken_spec_result = @kataken_spec_NG == 0 ? "合格" : "不合格"            
            @kataken_cpk_result = @kataken_cpk_NG == 0 ? "合格" : "不合格"
          end
      
          @kataken_check = "☑"
        else
          @kataken_check = "☐"
        end
      end
      

      if stage=="初期工程調査結果"
        @cpk_yotei=pro.deadline_at.strftime('%y/%m/%d')
        @cpk_kanryou=pro.end_at.strftime('%y/%m/%d')
        if pro.documents.attached?
          # 変数の設定
          partnumber = pro.partnumber  # ここには実際の値を設定してください
          # パスとファイル名のパターンを作成
          pattern = "/myapp/db/documents/*#{partnumber}*工程能力(Ppk)調査表*"
          Rails.logger.info "Path= #{pattern}"
          # パターンに一致するファイルを取得
          files = Dir.glob(pattern)
          # 各ファイルに対して処理を行う
          files.each do |file|
            # Excelファイルを開く
            if File.extname(file) == '.xlsx'
              workbook = Roo::Excelx.new(file) #xlsxの場合はこちらを使用
            elsif File.extname(file) == '.xls'
              workbook = Roo::Excel.new(file) #xlsの場合はこちらを使用
            end

            # 最初のシートを取得
            worksheet = workbook.sheet(0)

            # i4のセルの値を取得
            @cpk_person_in_charge = worksheet.cell(50, 71)
            @cpk_manager = worksheet.cell(50, 76)

            def cell_address_to_position(cell_address)
              col = cell_address.gsub(/\d/, '')
              row = cell_address.gsub(/\D/, '').to_i
            
              col_index = col.chars.map { |char| char.ord - 'A'.ord + 1 }.reduce(0) { |acc, val| acc * 26 + val }
              [row, col_index]
            end
            
            satisfied = "工程能力は満足している"
            not_satisfied = "工程能力は不足している"
            
            # チェックするセルの位置
            check_addresses = ["E", "N", "W", "AF", "AO", "AX", "BG", "BP", "BY"].map { |col| "#{col}44" }
            
            # 初期値
            satisfied_count = 0
            not_satisfied_count = 0
            
            # すべてのシートをループ
            workbook.sheets.each do |sheet_name|
              worksheet = workbook.sheet(sheet_name)
              
              check_addresses.each do |cell_address|
                row, col = cell_address_to_position(cell_address)
                cell_value = worksheet.cell(row, col)
                
                satisfied_count += 1 if cell_value == satisfied
                not_satisfied_count += 1 if cell_value == not_satisfied
              end
            end
            
            # 結果の設定
            if not_satisfied_count > 0
              @cpk_result = not_satisfied
            elsif satisfied_count > 0
              @cpk_result = satisfied
            else
              @cpk_result = "結果なし"  # この行は必要に応じて変更または削除してください
            end
            @cpk_satisfied_count=satisfied_count
            @cpk_not_satisfied_count=not_satisfied_count

            @cpk_person_in_charge  =worksheet.cell(50,76) #担当者名

            if worksheet.cell(3, 59) != nil
              @cpk_yotei  =worksheet.cell(3,59)
              @cpk_kanryou=worksheet.cell(3,59)
            end
          end
            @cpk_check="☑"
        else
            @cpk_check="☐"
        end
      end
      
      if stage=="試作製造指示書_営業"
        @shisaku_yotei=pro.deadline_at.strftime('%y/%m/%d')
        @shisaku_kanryou=pro.end_at.strftime('%y/%m/%d')
      end

      if stage=="金型製造指示書_営業"
        @kanagata_yotei=pro.deadline_at.strftime('%y/%m/%d')
        @kanagata_kanryou=pro.end_at.strftime('%y/%m/%d')
      end

      if stage=="設計計画書_金型設計"
        @plan_yotei=pro.deadline_at.strftime('%y/%m/%d')
        @plan_kanryou=pro.end_at.strftime('%y/%m/%d')
          if pro.documents.attached?
            # 変数の設定
            partnumber = pro.partnumber  # ここには実際の値を設定してください
            # パスとファイル名のパターンを作成
            pattern = "/myapp/db/documents/*#{partnumber}*設計計画書*"
            #pattern = "/myapp/db/documents/NT2394-P43_PM81EB_設計計画書.xls"
            Rails.logger.info "Path= #{pattern}"
            # パターンに一致するファイルを取得
            files = Dir.glob(pattern)
            # 各ファイルに対して処理を行う
            files.each do |file|
              # Excelファイルを開く
              if File.extname(file) == '.xlsx'
                workbook = Roo::Excelx.new(file) #xlsxの場合はこちらを使用
              elsif File.extname(file) == '.xls'
                workbook = Roo::Excel.new(file) #xlsの場合はこちらを使用
              end

              # 最初のシートを取得
              worksheet = workbook.sheet(0)

              # i4のセルの値を取得
              @plan_designer = worksheet.cell(4, 9)
              @plan_manager = worksheet.cell(5, 9)
              @plan_customer = worksheet.cell(6, 3)
              @plan_risk = worksheet.cell(41, 4).nil? ? "" : worksheet.cell(41, 4).to_s + worksheet.cell(42, 4).to_s
              @plan_opportunity = worksheet.cell(43, 4).nil? ? "" : worksheet.cell(43, 4).to_s + worksheet.cell(44, 4).to_s
              
              if worksheet.cell(10, 4) != nil
                @plan_yotei  =worksheet.cell(11, 4)
                @plan_kanryou=worksheet.cell(11, 6)
              end
            end
          end
      end

      if stage=="DR構想検討会議議事録_生産技術"
        @dr_setsubi_yotei=pro.deadline_at.strftime('%y/%m/%d')
        @dr_setsubi_kanryou=pro.end_at.strftime('%y/%m/%d')
          if pro.documents.attached?
            # 変数の設定
            partnumber = pro.partnumber  # ここには実際の値を設定してください
            # パスとファイル名のパターンを作成
            pattern = "/myapp/db/documents/*#{partnumber}*DR構想検討会議議事録*"
            Rails.logger.info "Path= #{pattern}"
            # パターンに一致するファイルを取得
            files = Dir.glob(pattern)
            # 各ファイルに対して処理を行う
            files.each do |file|
              # Excelファイルを開く
              if File.extname(file) == '.xlsx'
                workbook = Roo::Excelx.new(file) #xlsxの場合はこちらを使用
              elsif File.extname(file) == '.xls'
                workbook = Roo::Excel.new(file) #xlsの場合はこちらを使用
              end

              # 最初のシートを取得
              worksheet = workbook.sheet(0)

              # i4のセルの値を取得
              @dr_setsubi_designer = worksheet.cell(2, 17)
              @dr_setsubi_manager = worksheet.cell(2, 16)
              @dr_setsubi_equipment_name = worksheet.cell(5, 11) #K5    
              
              #@dr_setsubi_shiteki = worksheet.cell(11, 1)
              @dr_setsubi_shiteki = (11..25).map { |row| worksheet.cell(row, 1)&.to_s}.compact.join("\n")

              if worksheet.cell(10, 4) != nil
                @dr_setsubi_yotei  =worksheet.cell(5, 15)
                @dr_setsubi_kanryou=worksheet.cell(27,12)
              end
            end
              @dr_setsubi_check="☑"
          else
              @dr_setsubi_check="☐"
          end
      end

      if stage=="進捗管理票_生産技術"
        @dr_seigi_yotei=pro.deadline_at.strftime('%y/%m/%d')
        @dr_seigi_plan_kanryou=pro.end_at.strftime('%y/%m/%d')
          if pro.documents.attached?
            # 変数の設定
            partnumber = pro.partnumber  # ここには実際の値を設定してください
            # パスとファイル名のパターンを作成
            pattern = "/myapp/db/documents/*#{partnumber}*進捗管理票*"
            #pattern = "/myapp/db/documents/NT2394-P43_PM81EB_設計計画書.xls"
            Rails.logger.info "Path= #{pattern}"
            # パターンに一致するファイルを取得
            files = Dir.glob(pattern)
            # 各ファイルに対して処理を行う
            files.each do |file|
              # Excelファイルを開く
              if File.extname(file) == '.xlsx'
                workbook = Roo::Excelx.new(file) #xlsxの場合はこちらを使用
              elsif File.extname(file) == '.xls'
                workbook = Roo::Excel.new(file) #xlsの場合はこちらを使用
              end

              # 最初のシートを取得
              worksheet = workbook.sheet(0)

              #すみません、混乱を招いてしまったようで。Roo gemはExcelの日付をシリアル日付として読み込む場合があります。
              #Excelでは、日付は1900年1月1日からの日数として保存されます。
              #したがって、数値をRubyのDateオブジェクトに変換するために、Excelの日付のオフセット（1900年1月1日から数えた日数）
              #を使用する必要があります。
              #次の関数は、Excelのシリアル日付を日付文字列に変換します：

              def convert_excel_date(serial_date)
                # Excelの日付は1900年1月1日から数えた日数として保存されている
                base_date = Date.new(1899,12,30)
                # シリアル日付を日付に変換
                date = base_date + serial_date.to_i
                # 日付を文字列に変換
                date.strftime('%Y/%m/%d')
              end
              
              @progress_management_seigi_design_name = worksheet.cell(14, 8)           #H13 設計担当者名
              @progress_management_seigi_design_yotei = convert_excel_date(worksheet.cell(12, 6)) #F12 設計予定日
              @progress_management_seigi_design_kanryou = convert_excel_date(worksheet.cell(12, 7)) #G12 設計完了日
              
              @progress_management_seigi_assembly_name = worksheet.cell(27, 8)         #H27 組立担当者名
              @progress_management_seigi_assembly_yotei = convert_excel_date(worksheet.cell(26, 6)) #F26 組立予定日
              @progress_management_seigi_assembly_kanryou = convert_excel_date(worksheet.cell(26, 7)) #G26 組立完了日
              
              @progress_management_seigi_wiring_name = worksheet.cell(30, 8)           #H30 配線担当者名
              @progress_management_seigi_wiring_yotei = convert_excel_date(worksheet.cell(29, 6)) #F29 配線予定日
              @progress_management_seigi_wiring_kanryou = convert_excel_date(worksheet.cell(29, 7)) #G29 配線完了日
              
              @progress_management_seigi_program_name = worksheet.cell(34, 8)          #H34 プログラム担当者名
              @progress_management_seigi_program_yotei = convert_excel_date(worksheet.cell(33, 6)) #F33 プログラム予定日
              @progress_management_seigi_program_kanryou = convert_excel_date(worksheet.cell(33, 7)) #G33 プログラム完了日
               
          

              if worksheet.cell(10, 4) != nil
                @dr_seigi_yotei  =worksheet.cell(33, 6) #F33　プログラム予定日
                @dr_seigi_kanryou=worksheet.cell(33, 7) #G33 プログラム完了日
              end
            end
          end
      end

      if stage=="初期流動検査記録"
        @shoki_yotei=pro.deadline_at.strftime('%y/%m/%d')
        @shoki_kanryou=pro.end_at.strftime('%y/%m/%d')
      end

      if stage=="プロセス指示書"
        @wi_yotei=pro.deadline_at.strftime('%y/%m/%d')
        @wi_kanryou=pro.end_at.strftime('%y/%m/%d')
      end
      
    end

    @all_products.each do |all|
      stage = @dropdownlist[all.stage.to_i]
      if stage == "金型製作記録"
        Rails.logger.info "金型製作記録(添付資料確認前)"
        if all.documents.attached?
          pattern = "/myapp/db/documents/**/*.{xls,xlsx}"
          Rails.logger.info "Path= #{pattern}"
          # ディレクトリ内のExcelファイルを走査
          Dir.glob(pattern) do |file|
            # '金型製作記録'を含むファイルだけを対象に
            next unless file.include?('金型製作記録')
            Rails.logger.info "金型製作記録(添付資料確認後)"
            # ファイル形式に応じて適切なRooクラスを使用
            workbook = case File.extname(file)
                      when '.xlsx'
                        Roo::Excelx.new(file)
                      when '.xls'
                        Roo::Excel.new(file)
                      end
            workbook.sheets.each do |sheet|
              worksheet = workbook.sheet(sheet)
              # 最終行がnilの場合は、このシートの処理をスキップ
              next if worksheet.last_row.nil?
    
              # 各行を走査
              (1..worksheet.last_row).each do |i|
                row = worksheet.row(i)
                # E列がpartnumberと一致する場合、L列の値を@dieset_personに代入
                if row[4] == @partnumber
                  @dieset_person = row[11]
                  @kanagata_yotei        = row[9]
                  @kanagata_kanryou      = row[10]
                  @kanagata_katagouzou   = row[8]
                  @kanagata_remark       = row[12]
                end
              end
            end
          end
        end
      end
    end
    
  end


  #RailsでAxlsxを使ってxlsxを生成
  #https://qiita.com/necojackarc/items/0dbd672b2888c30c5a38

  #【Rails】 strftimeの使い方と扱えるクラスについて
  #https://pikawaka.com/rails/strftime

  def generate_xlsx
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(name: "登録データ一覧") do |sheet|
        styles = p.workbook.styles
        title = styles.add_style(bg_color: 'c0c0c0', b: true)
        header = styles.add_style(bg_color: 'e0e0e0', b: true)
  
        sheet.add_row ["登録データ一覧"], style: title
        sheet.add_row %w(ID 図番 材料コード 文書名 詳細 カテゴリー フェーズ 項目 登録日 完了予定日 完了日 達成度 ステイタス), style: header
        sheet.add_row %w(id partnumber materialcode documentname description category phase stage start_time deadline_at end_at goal_attainment_level status), style: header

    
        @products.each do |pro|      
        sheet.add_row [pro.id, pro.partnumber,pro.materialcode,pro.documentname,pro.description,@dropdownlist[pro.category.to_i],@dropdownlist[pro.phase.to_i],@dropdownlist[pro.stage.to_i],pro.start_time.strftime('%y/%m/%d'),pro.deadline_at.strftime('%y/%m/%d'),pro.end_at.strftime('%y/%m/%d'),pro.goal_attainment_level,pro.status]
        end
      end
      send_data(p.to_stream.read,
                type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                filename: "登録データ一覧(#{Time.now.strftime('%Y_%m_%d_%H_%M_%S')}).xlsx")
    end
  end

  
  def set_q
    @q = Product.ransack(params[:q])
  end


  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:documentname,:materialcode,:start_time, :deadline_at, :end_at,:status,:goal_attainment_level,:description,:category,:partnumber,:phase,:stage,documents:[])
  end

  

  def phase

    #@phases=Phase.all
    @phases = Phase.where(ancestry: nil)
    @pha=Phase.all

    
    #ドロップダウンリストの表示が数字のため、単語で表示するためにdropdownlistを設定。※なぜか288行が勝手に追加されるためSKIPで回避
    dropdownlist=[]
    dropdownlist.push("0")
    @pha.each do |p|
        if p.name!="SKIP" 
            dropdownlist.push(p.name)
        end
    end 
    @dropdownlist=dropdownlist

    phases_test=[]
    @pha.each do |p|
    phases_test.push(Phase.find(p.id).children)
    #@phases_test=Phase.find(p.id).children
    end
    @phases_test=phases_test

    
    #@phases1= Phase.find(1).children   # 製品
    #@phases2= Phase.find(2).children   # 文書
    #@phases3= Phase.find(3).children   # フェーズ1
    #@phases4= Phase.find(4).children # フェーズ2
    #@phases5= Phase.find(5).children # フェーズ3
    #@phases6= Phase.find(6).children # フェーズ4
    #@phases7= Phase.find(7).children # フェーズ5
    #@phases8= Phase.find(8).children # PPAP
    #@phases9= Phase.find(9).children # 8.3設計・開発
    #@phases10= Phase.find(10).children # 文書計画
    #@phases11= Phase.find(11).children # プロセス管理図
    #@phases12= Phase.find(12).children # 規定
    #@phases13= Phase.find(13).children # フロー
    #@phases14= Phase.find(14).children # 手順書
    #@phases15= Phase.find(15).children # 新規見直し記録
    #@phases16= Phase.find(16).children # 営業部
    #@phases17= Phase.find(17).children # 管理部
    #@phases18= Phase.find(18).children # 生産技術課
    #@phases19= Phase.find(19).children # 設計課
    #@phases20= Phase.find(20).children # プレス
    #@phases21= Phase.find(21).children # 表面処理
    #@phases22= Phase.find(22).children # 品質保証部
    #@phases23= Phase.find(23).children # 金型課
    #@phases24= Phase.find(24).children # 内部監査
    #@phases25= Phase.find(25).children # 購買先管理
    #@phases26= Phase.find(26).children # 顧客固有要求事項/外部文書
    #@phases27= Phase.find(27).children # 材料仕様書
    #@phases28= Phase.find(28).children # 顧客満足/SPR
    #@phases29= Phase.find(29).children # スキルマップ


  
  end


end