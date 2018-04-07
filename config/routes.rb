Rails.application.routes.draw do
  resources :topics do
    resources :posts, except: [:index]
  end
  resources :users, only: %i[new create]
  resources :advertisements
  resources :questions

  get 'about' => 'welcome#about'

  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
