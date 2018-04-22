Rails.application.routes.draw do
  resources :topics do
    resources :posts, except: [:index]
  end

  resources :posts, only: [] do
    resources :comments, only: %i[create destroy]
    resources :favorites, only: %i[create destroy]
    post '/up-vote' => 'votes#up_vote', as: :up_vote
    post '/down-vote' => 'votes#down_vote', as: :down_vote
  end

  resources :users, only: %i[new create show]
  resources :sessions, only: %i[new create destroy]
  resources :advertisements
  resources :questions

  get 'about' => 'welcome#about'
  post 'users/confirm' => 'users#confirm'
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
