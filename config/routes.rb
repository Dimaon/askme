Rails.application.routes.draw do
  root 'users#index'

  resources :users
  resources :questions, except: [:show, :new]
  resources :sessions, only: [:new, :create, :destroy]

  # Синонимы для урлов
  get 'sign_up' => 'users#new'
  get 'log_out' => 'sessions#destroy'
  get 'log_in' => 'sessions#new'
  get 'questions_search' => 'questions#search'

end
