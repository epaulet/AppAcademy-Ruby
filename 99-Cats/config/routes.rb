Rails.application.routes.draw do
  root to: 'cats#index'

  resources :cats
  resources :users, only: [:create, :new]
  resource :session, only: [:create, :new, :destroy]

  resources :cat_rental_requests, only: [:create, :new] do
    post 'approve', on: :member
    post 'deny', on: :member
  end
end
