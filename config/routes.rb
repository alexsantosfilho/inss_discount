Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"
  mount ActionCable.server => "/cable"

  root "employees#index"

  resource :session
  resources :passwords, param: :token

  resources :employees do
    member do
      patch :update_salary
      post :update_salary
      get :salary_report
    end

    collection do
      get :report
      get :calculate_inss 
    end
  end


  get "/auth/failure" => "sessions/omni_auths#failure", as: :omniauth_failure
  get "/auth/:provider/callback", to: "sessions#omniauth", as: :omniauth_callback

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
