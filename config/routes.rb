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

  
  # other controllers
  get 'ui(/:action)', controller: 'ui'
  resources :categories, only: [:show]
end
