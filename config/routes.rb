Rails.application.routes.draw do
  resources :bike_services
  resources :chains
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/home', to: 'home#index', as: 'homepage'
  get '/login', to: 'login#redirect_oauth', as: 'login_redirect_oauth'
  get '/oauth-callback', to: 'login#authenticate', as: 'after_login'
  get '/profile', to: 'user_profile#index', as: 'user_profile'
  root 'home#index'
end
