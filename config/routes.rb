Rails.application.routes.draw do
  root 'statics#index'

  # Statics（一覧/詳細 + カスタムページ）
  resources :statics, only: [:index, :show] do
    collection do
      get  :upload   # /statics/upload (GET フォーム表示)
      post :upload   # /statics/upload (POST 取込実行)
      get  :search   # /statics/search
      get  :groupall # /statics/groupall
      get  :about    # /statics/about   => about_statics_path
      get  :civic    # /statics/civic   => civic_statics_path
    end
  end

  devise_for :users

  # Tweets（標準REST + 追加の一覧系はcollectionで）
  resources :tweets do
    collection do
      get :eventall
      get :area
      get :genre
      get :month
      get :name
      get :search
    end
  end

  resources :associations
  resources :maps, only: [:index]
end

