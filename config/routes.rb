Rails.application.routes.draw do

  #scope '/cv' do
  scope '/:locale' do
    get 'front-end', to: 'frontend#index', as: 'frontend'
    get 'robot', to: 'home#robot', as: 'robot'
    get 'prog', to: 'home#prog', as: 'prog'
    get 'no_portfolio', to: 'home#no_portfolio', as: 'no_portfolio'
    get 'conception', to: 'home#conception', as: 'conception'
    get 'armoire', to: 'home#cupboard', as: 'cupboard'
    get 'contact', to: 'home#contact', as: 'contact'
    get 'about', to: 'home#about', as: 'about'

    get 'laser', to: 'projects#chuck_laser', as: 'chuck_laser'
    get 'pump', to: 'projects#mattress_pump', as: 'mattress_pump'
    
    get 'thailand', to: 'trips#thailand', as: 'thailand'

    get 'trips', to: redirect('https://pascalr.github.io/voyage/')
    
    resources 'projects', only: 'index'
    resources 'tools', only: 'index'
    get '/', to: "home#index", as: 'home'
  end
  #end
  root "home#index"
  #
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
