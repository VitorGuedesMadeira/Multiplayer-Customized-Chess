Rails.application.routes.draw do
  devise_for :users
  resources :games, except: %i[destroy] do
    patch :move_piece, on: :member
    patch :promotion, on: :member
    post :check_positions, on: :member
    get :join, on: :member
  end
  root "home#index"
end
