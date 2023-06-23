
class TouansController < ApplicationController

  def member_current_status
    @touans = Touan.all
    @user = current_user
    @users=User.all

  end

  def xlsx
    @touans = Touan.all
    respond_to do |format|
      format.html
      format.xlsx do
        generate_xlsx
      end
    end
  end

  def import_test
    # fileはtmpに自動で一時保存される
    Testmondai.import_test(params[:file])
    redirect_to testmondai_touan_path
  end

  def import_kaitou
    # fileはtmpに自動で一時保存される
    Touan.import_kaitou(params[:file])
    redirect_to touans_path
  end

  def delete_testmondai
    @testmondai = Testmondai.find(params[:testmondai_id]) # 変更
    @testmondai.destroy
    respond_to do |format|
      #format.html { redirect_to touans_url, notice: "Testmondai was successfully destroyed." }
      format.html { redirect_to testmondai_touan_path, notice: "Testmondai was successfully destroyed." } # 変更
      format.json { head :no_content }
    end
  end

  def testmondai
    @user = current_user
    @testmondais=Testmondai.all
  end


  def delete_related
    target_date = DateTime.parse(params[:target_date])
    Touan.where(user_id: current_user.id, created_at: (target_date - 1.minute)..(target_date + 1.minute)).destroy_all
  
    flash[:notice] = "関連するTouanレコードを削除しました。"
    redirect_to touans_url # 削除後にリダイレクトするパスを指定
  end

  def destroy
    @touan = Touan.find(params[:id])
    @touan.destroy
    respond_to do |format|
      format.html { redirect_to touans_url, notice: "Touan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def new 
  @user = current_user
  @testmondais = Testmondai.where(kajyou: params[:kajyou])

  # 全ての Testmondai を取得
  all_testmondais = Testmondai.where(kajyou: params[:kajyou])

  # 各問題の seikairitsu と total_answers を計算
  testmondai_stats = all_testmondais.map do |testmondai|
    total_answers = Touan.where(mondai_no: testmondai.mondai_no, user_id: @user.id).count
    correct_answers = Touan.where(mondai_no: testmondai.mondai_no, user_id: @user.id, seikai: true).count
    seikairitsu = correct_answers.to_f / total_answers * 100 if total_answers > 0

    {
      testmondai: testmondai,
      seikairitsu: seikairitsu || 0,
      total_answers: total_answers
    }
  end

  # seikairitsu と total_answers が低い Testmondai を選ぶ
  some_threshold_seikairitsu=0.5
  some_threshold_total_answers=5

  low_testmondai_stats = testmondai_stats.select do |stat|
    stat[:seikairitsu] < some_threshold_seikairitsu && stat[:total_answers] < some_threshold_total_answers
  end

  # ランダムに10個の Testmondai を選ぶ
  selected_testmondais = low_testmondai_stats.sample(10).map { |stat| stat[:testmondai] }

  @touans = TouanCollection.new(selected_testmondais, @testmondais, @user)
  end

  def create
    @user = current_user # 追加
    @touans = TouanCollection.new(touans_params, [],@user)
    if @touans.save
    #  redirect_to touans_url
    #else
    #  render :new
    #end
      grouped_touans = @touans.collection.group_by { |touan| [touan.user_id, touan.created_at.change(usec: 0)] }

      grouped_touans.each do |(user_id, created_at), touans|
        total = touans.size
        correct_answers = touans.select { |touan| touan.kaito == touan.seikai }.size
        seikairitsu = correct_answers.to_f / total.to_f

        touans.each do |touan|
          touan.update_attribute(:seikairitsu, seikairitsu)
        end
      end

      redirect_to touans_url
    else
      render :new
    end
  end

  def index
    #@touans = Touan.all

    @products = Product.all
    @touans = Touan.where(user_id:current_user)
    @user = current_user

    @auditor = current_user.auditor
    @iatf_data_audit = Iatf.where(audit: "2")
    @iatf_data_audit_sub = Iatf.where(audit: "1")

    @csrs=Csr.all
    @iatflists=Iatflist.all


    case current_user.owner
    when 'sales'
      @iatf_data = Iatf.where(sales: "2")
      @iatf_data_sub = Iatf.where(sales: "1")
    when 'process_design'
      @iatf_data = Iatf.where(process_design: "2")
      @iatf_data_sub = Iatf.where(process_design: "1")
    when 'production'
      @iatf_data = Iatf.where(production: "2")
      @iatf_data_sub = Iatf.where(production: "1")
    when 'inspection'
      @iatf_data = Iatf.where(inspection: "2")
      @iatf_data_sub = Iatf.where(inspection: "1")
    when 'release'
      @iatf_data = Iatf.where(release: "2")
      @iatf_data_sub = Iatf.where(release: "1")
    when 'procurement'
      @iatf_data = Iatf.where(procurement: "2")
      @iatf_data_sub = Iatf.where(procurement: "1")
    when 'equipment'
      @iatf_data = Iatf.where(equipment: "2")
      @iatf_data_sub = Iatf.where(equipment: "1")
    when 'measurement'
      @iatf_data = Iatf.where(measurement: "2")
      @iatf_data_sub = Iatf.where(measurement: "1")
    when 'policy'
      @iatf_data = Iatf.where(policy: "2")
      @iatf_data_sub = Iatf.where(policy: "1")
    when 'satisfaction'
      @iatf_data = Iatf.where(satisfaction: "2")
      @iatf_data_sub = Iatf.where(satisfaction: "1")
    when 'audit'
      @iatf_data = Iatf.where(audit: "2")
      @iatf_data_sub = Iatf.where(audit: "1")
    when 'corrective_action'
      @iatf_data = Iatf.where(corrective_action: "2")
      @iatf_data_sub = Iatf.where(corrective_action: "1")
    end
  end

  def kekka
    @touans = Touan.where(created_at: Time.parse(params[:created_at]) - 1.minute..Time.parse(params[:created_at]) + 1.minute)
    @user = current_user

    @touans.each do |touan|
      total_answers = Touan.where(kajyou: touan.kajyou, user_id: current_user.id).where("mondai_no = ?", touan.mondai_no).count
      correct_answers = Touan.where(kajyou: touan.kajyou, user_id: current_user.id).where("id <= ? AND mondai_no = ? AND seikai = kaito", touan.id, touan.mondai_no).count

      touan.seikairitsu = correct_answers.to_f / total_answers * 100
      touan.total_answers = total_answers
      touan.correct_answers = correct_answers
    end

  end

  private

  def touans_params
    params.require(:touans).map do |p|
      p.permit(:kajyou, :kaito,:mondai,:mondai_a,:mondai_b,:mondai_c,:user_id,:seikai,:kaisetsu,:mondai_no,:seikairitsu,:total_answers,:correct_answers,:rev,:created_at,:updated_at)
    end
  end

  def generate_xlsx
    Axlsx::Package.new(encoding: 'UTF-8') do |p|
      p.workbook.add_worksheet(name: "登録答案一覧") do |sheet|
        styles = p.workbook.styles
        title = styles.add_style(bg_color: 'c0c0c0', b: true)
        header = styles.add_style(bg_color: 'e0e0e0', b: true)
  
        sheet.add_row ["登録答案一覧"], style: title
        sheet.add_row %w(id 箇条 問題番号 参考URL 問題 選択肢a 選択肢b 選択肢c 正解 解説 ユーザーの回答 ユーザーID 回答数 正解数 正解率 作成日 更新日), style: header
        sheet.add_row %w(id kajyou mondai_no rev mondai mondai_a mondai_b mondai_c seikai kaisetsu kaito user_id total_answers correct_answers seikairitsu created_at updated_at), style: header
    
        @touans.each do |t|
        sheet.add_row [t.id, t.kajyou, t.mondai_no,t.rev,t.mondai,t.mondai_a,t.mondai_b,t.mondai_c,t.seikai,t.kaisetsu,t.kaito,t.user_id,t.total_answers,t.correct_answers,t.seikairitsu,t.created_at,t.updated_at]
        end
      end

      send_data(p.to_stream.read,
                type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                filename: "登録答案一覧(#{Time.current.strftime('%Y_%m_%d_%H_%M_%S')}).xlsx")
    end
  end

end
