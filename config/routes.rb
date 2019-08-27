Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/test", to: "test#index"
  root to: 'pages#index'
  get '/search', to: 'pages#search'
  resources :stocks
  resources :users
end
