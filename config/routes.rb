Myflix::Application.routes.draw do
  root to: 'pages#front'
   
  # videos controller
  get '/home', to: 'videos#index'
  resources :videos, only: [:show] do
    collection do 
      post :search, to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end
  
  # users controller
  get '/register', to: 'users#new'
  resources :users, only: [:create, :show]
  
  # sessions controller
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  resources :sessions, only: [:create]

  # queue items controller
  get '/my_queue', to: 'queue_items#index'
  post '/update_queue', to: 'queue_items#update_queue'
  resources :queue_items, only: [:create, :destroy]

  # forgot_password controller
  get '/forgot_password', to: 'forgot_passwords#new'
  get '/forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :forgot_passwords, only: [:create]

  # password_resets controller
  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired_token'

  
  # other controllers
  get 'ui(/:action)', controller: 'ui'
  resources :categories, only: [:show]
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]
end
