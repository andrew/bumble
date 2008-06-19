class PostsController < ApplicationController

  resources_controller_for :posts
  
  before_filter :login_required, :except => [:index, :show]

  private
  
  def find_resources
    klass = params[:klass].blank? ? Post : class_from_params(params[:klass].capitalize)
    logged_in_scope(klass).paginate :page => params[:page], :order => 'created_at DESC'
  end

  def find_resource
    logged_in_scope.find_by_permalink(params[:id]) or logged_in_scope.find(params[:id])
  end
  
  def new_resource
    klass = (params[:post].nil? or params[:post][:type].nil?) ? Post : class_from_params(params[:post][:type])
    returning klass.new(params[resource_name]) do |post|
      post.user = current_user
    end
  end

end