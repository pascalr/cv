Rails.application.routes.draw do

  #scope '/cv' do
  scope '/:locale' do
    get 'robot', to: 'home#robot', as: 'robot'
    get 'prog', to: 'home#prog', as: 'prog'
    get 'conception', to: 'home#conception', as: 'conception'
    get 'armoire', to: 'home#cupboard', as: 'cupboard'

    get 'laser', to: 'projects#chuck_laser', as: 'chuck_laser'
    get 'pump', to: 'projects#mattress_pump', as: 'mattress_pump'
    
    get 'thailand', to: 'trips#thailand', as: 'thailand'
    
    resources 'trips', only: 'index'
    resources 'projects', only: 'index'
    get '/', to: "home#index", as: 'home'
  end
  #end
  root "home#index"
  #
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
