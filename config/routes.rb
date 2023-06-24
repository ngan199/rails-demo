Rails.application.routes.draw do
  # resources :users do 
  #   resources :transactions
  # end
  
  # get 'transactions/show'
  # get 'transactions/new'
  # get 'transactions/index'
  # post 'transactions/create'
  # get 'transactions/edit'
  # patch 'transactions/update'
  # get 'transactions/destroy'

  resources :transactions
  
  devise_for :users
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: "home#index"
  # Defines the root path route ("/")
  # root "articles#index"
end
