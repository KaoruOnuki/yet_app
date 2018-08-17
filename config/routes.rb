Rails.application.routes.draw do
  root "users#new"
  resources :words do
    post :confirm, on: :collection
  end
  resources :users
  resources :sessions
  resources :contacts

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
