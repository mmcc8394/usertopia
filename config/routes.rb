Rails.application.routes.draw do
  get 'home/show'

  resource :login, only: [ :new, :create, :destroy ]
  resources :users do
    member do
      get 'edit_password'
      put 'update_password'
    end
  end

  root 'home#show'
end
