Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :reservations, only: %i[index new create]

  get "up" => "rails/health#show", as: :rails_health_check

  root "rooms#index"
end
