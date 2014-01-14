OmhFrontend::Application.routes.draw do
  resources :users, only: [:new, :create]

  root to: 'welcome#index'
end
