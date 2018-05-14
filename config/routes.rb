Rails.application.routes.draw do
  root 'users#index'

  resources :users
  resources :questions, except: [:show, :new]
  resource :session, only: [:new, :create, :destroy]

  # Синонимы для урлов
  get 'questions_search' => 'questions#search'

end
