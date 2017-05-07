Rails.application.routes.draw do
  root "pages#show"
  devise_for :users, controllers: {
    registrations: "registrations",
  }
  resources :images do
    resources :comments, except: :show
    resources :likes, only: [:create, :destroy]
    resources :book_marks, only: [:create, :destroy]
    resources :reports, only: :create
  end
  resources :comments, only: :index do
    resources :reply_comments, except: :show
  end
  resources :popular_images, only: :index
  resources :follow_users, only: :index
  resources :users, only: [:show, :update] do
    resources :book_marks, only: :index
  end
end
