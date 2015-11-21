Rails.application.routes.draw do
  root to: "subs#index"
  resources :users, only: [:new, :create, :show]
  resources :subs
  resource :session, only: [:new, :destroy, :create]
end
