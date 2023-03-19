Rails.application.routes.draw do
  get 'pages/home'
  get 'pages/vcard'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resource :ai, controller: :ai

  # Defines the root path route ("/")
  root "ai/request_threads#index"

  resources :ai_requests
  
  namespace :ai do
    resources :request_threads do 
      resources :threaded_requests, only: [:new, :create], controller: "request_threads/threaded_requests"
    end
    resources :image_requests, controller: "image_requests"
    resources :threaded_requests, only: [:show], controller: "threaded_requests" do 
      member do
        get :debug
      end
    end
  end
end
