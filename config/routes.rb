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

    resources :faq_categories do
      member do
        get :move_up
        get :move_down
      end

      resources :faqs, except: [ :index, :show ] do
        member do
          get :move_up
          get :move_down
        end
      end
    end

    resources :posts
    resources :messages, only: [ :index ]
  end

  get 'blog', to: 'blogs#index', as: :blog
  get 'blog/:url', to: 'blogs#show', as: :blog_show
  get ':url', to: 'web_pages#show'
end
