Rails.application.routes.draw do
  get 'home/show'

  resource :login, except: [ :index ] do
    collection do
      post 'request_password_reset'
    end
  end

  resources :users do
    member do
      get 'edit_password'
      put 'update_password'
      get 'password_reset'
    end
  end

  root 'home#show'
end
