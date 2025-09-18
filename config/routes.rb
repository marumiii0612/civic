Rails.application.routes.draw do
  resources :statics, only: [:index, :show, :about, :civic] do
    collection do
      get  :upload   # /statics/upload (GET)
      post :upload   # /statics/upload (POST)
      get  :search
      get  :groupall
      get  :about
      get  :civic
    end
  end
  patch 'tweets/:id' => 'tweets#update'
  delete 'tweets/:id' => 'tweets#destroy'
  get 'tweets/:id/edit' => 'tweets#edit', as:'edit_tweet'
  get 'tweets/eventall' => 'tweets#eventall'
  get 'tweets/area' => 'tweets#area'
  get 'tweets/genre' => 'tweets#genre'
  get 'tweets/month' => 'tweets#month'
  get 'tweets/name' => 'tweets#name'
  get 'tweets/search' => 'tweets#search'
  devise_for :users
  resources :tweets
  resources :associations
  root 'statics#index'
  resources :maps, only: [:index]
end
