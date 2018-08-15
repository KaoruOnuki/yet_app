Rails.application.routes.draw do
  root "users#new"
  resources :words do
    post :confirm, on: :collection
  end
  resources :users
  resources :sessions
end
