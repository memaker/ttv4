Ttv4::Application.routes.draw do
  get "dashboard/index"

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
  resources :terms
end
