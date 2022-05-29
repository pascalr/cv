Rails.application.routes.draw do
  get 'home', to: 'home#index'
  get 'robot', to: 'home#robot', as: 'robot'
  get 'prog', to: 'home#prog', as: 'prog'
  get 'conception', to: 'home#conception', as: 'conception'
  get 'armoire', to: 'home#cupboard', as: 'cupboard'

  get 'laser', to: 'projects#chuck_laser', as: 'chuck_laser'
  
  resources 'projects', only: 'index'

  root "home#index"
  #
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
