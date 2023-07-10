

class ProductsController < ApplicationController
  require 'csv'
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :phase, only: %i[ graph calendar new edit show index index2 index3 index8 index9 download xlsx generate_xlsx]


  #  @touan = Touan.find(params[:id])
  #  @touan.kaito = params[:touan][:kaito]
  #  if @touan.save
  #    redirect_to product_path, notice: '登録しました。'
  #  else
  #    render :test
  #  end
  #end



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

  def update
    #Rails7で画像の保存にActiveStorage使ってみよう(導入からリサイズまで)
    #https://qiita.com/asasigure/items/311473d25fb3ec97f126

    #ActiveStorage で画像を複数枚削除する方法
    #https://h-piiice16.hatenablog.com/entry/2018/09/24/141510

    #Active Storageを使用して添付ファイル(アップロード)を簡単に管理する
    #https://www.petitmonte.com/ruby/rails_attachment.html

    #@product = Product.find(params[:id])
    #@product.update params.require(:product).permit(:partnumber, documents: []) # POINT
    #redirect_to @product


    product = Product.find(params[:id])
    #if params[:product][:detouch]=='1'
    if params[:product][:detouch]
       params[:product][:detouch].each do |image_id|
        #image = product.files.find(image_id)
        image = @product.documents.find(image_id)
        image.purge
       end
    end
   #【rails】update_attributes→updateを使う
   #update_attributesはrails6.1から削除されたそうです。
   #https://qiita.com/yuka_nari/items/b04c872d4eb2e5347fdb

   if product.update(product_params)
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