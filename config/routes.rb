Rails.application.routes.draw do
  # match 'sitemap.xml' => 'posts#sitemap', :as => :sitemap

  resources :posts do
    collection do
      get :search
    end
    resources :comments
  end

  resources :comments do
    member do
      get :approve
      get :reject
    end
  end

  resources :password_resets
  resources :users do
    member do
      get :delete
    end
  end
  match '/login' => 'user_sessions#new', :as => :login, :via => 'get'
  match '/logout' => 'user_sessions#destroy', :as => :logout
  resource :user_session
  match '/activate/:activation_code' => 'users#activate', :as => :activate
  root :to => 'posts#index'
end