Rails.application.routes.draw do
  resources :games, except: %i[destroy] do
    patch "", to: 'games#move_piece'
  end
  root "home#index"
end
