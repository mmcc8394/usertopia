Rails.application.routes.draw do
  get 'home/show'

  get 'login/new'
  post 'login/create'
  delete 'login/destroy'

  resources :users

  root 'home#show'
end
