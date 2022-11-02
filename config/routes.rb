Rails.application.routes.draw do
  get 'pages/home'
  get 'pages/vcard'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resource :ai, controller: :ai

  # Defines the root path route ("/")
  root "pages#home"
end
