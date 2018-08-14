Rails.application.routes.draw do
  root "words#index"
  resources :words do
    post :confirm, on: :collection
  end
  resources :users
end
