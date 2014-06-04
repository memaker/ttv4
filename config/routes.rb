Ttv4::Application.routes.draw do
  resources :leads


  resources :tweets


  get "tweets/destroy"

  get "tweet/delete"

  namespace :api, defaults: {format: 'json'} do
    # /api/... Api::
    namespace :v1 do
      resources :leads
    end
    namespace :v2 do
      resources :leads
    end
  end
  
  resources :corpus_leads


  resources :anews


  authenticated :user do
    root :to => 'terms#index'
  end
  root :to => "home#index"

  devise_for :users
  resources :corpus_anews
  resources :filters
  resources :users
  resources :terms do
    member do
      get 'dashboard'
      get 'showgender'
      get 'showdatetime'
      get 'showlocation'
      get 'showlist'
      get 'showlead'
      get 'showuserlist'
      get 'delete_lead'
    end
  end

  match '/help' => 'pages#help'
end
