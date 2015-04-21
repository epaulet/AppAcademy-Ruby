Rails.application.routes.draw do
  root to: 'subs#index'

  resources :users
  resource :session, only: [:new, :create, :destroy]
  resources :subs, except: [:destroy]
  resources :posts, except: [:index, :destroy]
  resources :comments, except: [:index, :edit, :update, :destroy]
end
