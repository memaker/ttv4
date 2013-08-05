Ttv4::Application.routes.draw do
  resources :searches


  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
  resources :terms
  resources :dashboard
end
