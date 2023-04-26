Rails.application.routes.draw do
  resources :games, except: %i[destroy]
  root "home#index"
end
