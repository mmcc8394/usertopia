Rails.application.routes.draw do
  root 'home#show'

  namespace :admin do
    resources :users do
      member do
        get 'edit_password'
        put 'update_password'
      end
    end

    resource :login, except: [ :index ] do
      collection do
        get 'lost_password_email'
        post 'request_password_reset'
      end
    end

    resources :posts
  end
end
