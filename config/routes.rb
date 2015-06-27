OmhFrontend::Application.routes.draw do
  resources :users, only: [:create]
  post 'users/log_in', to: 'users#log_in', as: :user_log_in
  post 'users/log_out', to: 'users#log_out', as: :user_log_out

  root to: 'welcome#index'
end
