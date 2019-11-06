Rails.application.routes.draw do
  get 'home/show'

  resource :login, only: [ :new, :create, :destroy ]
  resources :users

  root 'home#show'
end
