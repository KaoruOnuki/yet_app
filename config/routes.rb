Rails.application.routes.draw do
  root "users#new"

  resources :words do
    post :confirm, on: :collection
  end
  get '/test_word', to: 'words#test_word'
  resources :users
  resources :sessions
  resources :contacts

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  resources :conversations do
    resources :messages
  end

  resources :relationships, only: [:create, :destroy]

  get '/to_slack', to: 'words#to_slack', as: 'button'
end
