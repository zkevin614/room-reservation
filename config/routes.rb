Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :reservations, only: %i[index new create] do
    collection do
      get :upcoming
    end

    member do
      post :cancel
    end
  end

  namespace :admin do
    resources :sites, except: [:show]
    resources :rooms, except: [:show]

    resources :reservations, only: [:index] do
      member do
        post :approve
        post :deny
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "rooms#index"
end
