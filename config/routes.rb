ActionController::Routing::Routes.draw do |map|
  map.resources :posts, :collection => {:search => :get}, :has_many => :comments
  map.resources :comments
  map.resources :password_resets, :except => [:index, :show, :destroy]
  map.resources :users

  map.login     '/login',   :controller => "user_sessions", :action => "new", :conditions => {:method => :get}
  map.logout    '/logout',  :controller => "user_sessions", :action => "destroy"
  map.resource  :user_session, :as => 'login', :only => :create

  map.activate  '/activate/:activation_code', :controller => 'users',         :action => 'activate'

  map.root      :controller => "posts"
end
