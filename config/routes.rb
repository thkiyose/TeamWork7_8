Rails.application.routes.draw do
  root to: 'blogs#index'
  resources :sessions, only: %i(new create destroy)
  resources :users,:only => %i[new create show edit update]
  resources :blogs
end
