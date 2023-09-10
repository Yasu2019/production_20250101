Rails.application.routes.draw do

  #このルーティング設定がconfig/routes.rbに追加されていれば、http://localhost:3000/letter_opener 
  #にアクセスすると、letter_opener_webのインターフェースが表示されるはずです。
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  

  #【Rails】devise-two-factorを使った2段階認証の実装方法【初学者】
  #https://autovice.jp/articles/172
  # 以下を追記
  resources :two_step_verifications, only: [:new, :create]

  # 新しいルートを追加
  get 'verify/:token', to: 'verification#verify', as: :verify_token


  get 'products/export_to_excel', to: 'products#export_to_excel',  as: 'export_to_excel_product' # IATF要求事項説明ページ
  
  get 'measurementequipments/index' => 'measurementequipments#index',                 as: 'index_measurementequipments' # サプライヤーのインデックスページ
  resources :measurementequipments
  
  get 'suppliers/index' => 'suppliers#index',                 as: 'index_suppliers' # サプライヤーのインデックスページ
  resources :suppliers
  #get 'touan/new'

  #Rails7でDeviseを導入される方へ
  #https://kobacchi.com/rails7-devise-responded-to-turbo/
  devise_for :users , controllers: {
    sessions: 'users/sessions'
  }

  devise_scope :user do
    patch '/users/sign_in', to: 'users/sessions#create'
    # 以下を追記
    get '/users/two_step_verification', to: 'users/sessions#new_two_step_verification'
    post '/users/two_step_verification', to: 'users/sessions#create_two_step_verification'

  end

  #get 'touans/delete_testmondai' => 'touans#delete_testmondai',                 as: 'delete_testmondai' # テストの結果表示ページ

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"

  get 'touans/testmondai' => 'touans#testmondai',                 as: 'testmondai_touan' # テストの結果表示ページ
  #post 'touans/test_save' => 'touans#test_save',      as: 'test_save_touan'
  get 'touans/index' => 'touans#index',                 as: 'index_touan' # IATF要求事項説明ページ
  get 'touans/kekka' => 'touans#kekka',                 as: 'kekka_touan' # テストの結果表示ページ
  get 'touans/xlsx' => 'touans#xlsx',                 as: 'xlsx_touan'
  get 'touans/member_current_status' => 'touans#member_current_status',                 as: 'member_current_status_touan'

# 以下のコードを追加
resources :touans, only: [:index, :new, :create, :destroy] do
  collection do
    delete 'delete_related'
    delete 'delete_testmondai', as: 'delete_testmondai' # 追加
  end
end
# 追加ここまで

  get 'products/process_design_plan_report' => 'products#process_design_plan_report',    as: 'rubyxl_product' # IATF要求事項説明ページ
  get 'products/apqp_plan_report'           => 'products#apqp_plan_report',              as: 'rubyxl_apqp_plan_report_product' # IATF要求事項説明ページ
  get 'products/apqp_approved_report'       => 'products#apqp_approved_report',          as: 'rubyxl_apqp_approved_report_product' # IATF要求事項説明ページ

  get 'products/iot' => 'products#iot',                   as: 'iot_product' # IATF要求事項説明ページ
  get 'products/graph' => 'products#graph',               as: 'graph_product'
  get 'products/calendar' => 'products#calendar',         as: 'calendar_product'
  get 'products/training' => 'products#training',         as: 'training_product'
  get 'products/index2' => 'products#index2',             as: 'index2_product'
  get 'products/index3' => 'products#index3',             as: 'index3_product' # 全Itemのステイタス一覧
  get 'products/index4' => 'products#index4',             as: 'index4_product' # IATF要求事項説明ページ
  get 'products/index8' => 'products#index8',             as: 'index8_product' # 製品の達成度
  get 'products/index9' => 'products#index9',             as: 'index9_product' # 全アイテムの日付一覧

  get 'products/xlsx' => 'products#xlsx',                 as: 'xlsx_product'
  get 'products/download' => 'products#download',         as: 'download_product'
  get 'products/process_design_download' => 'products#process_design_download', as: 'process_design_download'

  #post 'products/iot_import' => 'products#iot_import',     as: 'iot_import_product' # IATF要求事項説明ページ

  root to: 'products#index'
  #root to: 'users#sign_in'

  #【Ruby on Rails】CSVインポート
  #https://qiita.com/seitarooodayo/items/c9d6955a12ca0b1fd1d4

  
  resources :products, only: [:new, :create, :show, :edit] do
    collection { post :import }
    member do
      get 'verify_password/:blob_id', to: 'downloadable#verify_password', as: :product_verify_password
      post 'verify_password/:blob_id', to: 'downloadable#verify_password_post', as: :product_verify_password_post
      post 'download', to: 'downloadable#download'
    end
  end
  
  


  resources :suppliers, only: [] do
    member do
      get 'verify_password/:blob_id', to: 'downloadable#verify_password', as: :supplier_verify_password
      post 'download', to: 'downloadable#download'
    end
  end
  
  resources :touans, only: [] do
    member do
      get 'verify_password/:blob_id', to: 'downloadable#verify_password', as: :touan_verify_password
      post 'download', to: 'downloadable#download'
    end
  end
  
  resources :touans do
    collection { post :import_test }
    collection { post :import_kaitou }

  end

  post 'products/verify_password/:blob_id', to: 'downloadable#verify_password_post', as: :product_verify_password_post


  #resources :users, only: [] do
  #  collection do
  #    get 'instructions'
  #  end
  #end

end

