class PostsController < ApplicationController

  resources_controller_for :posts
  
  before_filter :login_required, :except => [:index, :show]

  response_for :create do |format|
    if resource_saved?
      format.html do
        redirect_to post_path(resource.post), :status => :moved_permanently
      end
      format.js do
        @posts = find_resources
        render :partial => 'posts'
      end
    else
      format.html do
        render :action => "new"
      end
      format.js do
        render :text => "some error message"
      end
    end
  end

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