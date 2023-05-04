Rails.application.routes.draw do
  resources :games, except: %i[destroy] do
    patch :move_piece, on: :member
    post :get_positions, on: :member
  end
  root "home#index"
end
