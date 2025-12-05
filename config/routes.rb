Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  resources :decks do
    resources :cards do
      resources :hints, only: %i[ new create edit destroy update ] do
        collection do
          get :close   # /decks/:deck_id/cards/:card_id/hints/close
        end
      end
    end
    collection do
      get :my_decks
    end
    resources :play_sessions, only: %i[create show] do
      member do
        patch :answer   # 正誤の自己申告を送る
        get   :result   # 結果画面
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "decks#index"
end
