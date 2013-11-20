Ttv4::Application.routes.draw do

  resources :filters


  authenticated :user do
    root :to => 'terms#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
  resources :terms do
    member do
      get 'showgender'
      get 'showdatetime'
      get 'showlocation'
      get 'showlist'
    end
  end
end
