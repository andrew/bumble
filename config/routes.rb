ActionController::Routing::Routes.draw do |map|
  
  map.resources :users
  map.resource :session
  map.resources :posts, :has_many => :comments
  
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.signup '/signup', :controller => 'users', :action => 'new', :resource_path => '/users/new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  
  map.post_class '/:klass', :controller => 'posts', :action => 'index', :resource_path => '/posts'
  map.root :controller => 'posts', :resource_path => '/posts'
  
end
