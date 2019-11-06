Rails.application.routes.draw do
  get 'home/show'

  resources :login, only: [ :new, :create ]
  resources :users

  root 'home#show'
end
