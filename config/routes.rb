Rails.application.routes.draw do
  get 'sessions/new'

  root to: 'static_pages#home'
  get    'signup', to: 'users#new'
  get    'login' , to: 'sessions#new'
  post   'login' , to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :sessions, only: [:new, :create, :destroy]
  resources :users
  resources :microposts
  resources :relationships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]

  resources :users do
    member do
     get :following, :followers, :like_microposts
    end
  end
  
  # post '/like/:id', to: 'likes#like', as: 'like'
  # delete  '/unlike/:id', to: 'likes#unlike', as: 'unlike'

end