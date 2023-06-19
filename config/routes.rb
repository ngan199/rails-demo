Rails.application.routes.draw do
  get 'transactions/show'
  get 'transactions/new'
  post 'transactions/create'
  get 'transactions/edit'
  patch 'transactions/update'
  get 'transactions/destroy'

  get 'expenses/show'
  get 'expenses/new'
  post 'expenses/create'
  get 'expenses/edit'
  patch 'expenses/update'
  get 'expenses/destroy'
  get 'expenses/index'
  
  devise_for :users
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: "home#index"
  # Defines the root path route ("/")
  # root "articles#index"
end
