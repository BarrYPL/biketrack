Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/home', to: 'home#index'
  get '/login', to: 'login#redirect_oauth'
  get '/oauth-callback' to: 'login#authenticate'
  root 'home#index'
end
