class CommentsController < ApplicationController

  resources_controller_for :comments
  nested_in :post do
    logged_in_scope.find_by_permalink(params[:post_id]) or logged_in_scope.find(params[:post_id])
  end
  
  response_for :show, :index do |format|
    format.html do
      redirect_to post_path(resource.post), :status => :moved_permanently
    end
  end

  private

  def new_resource
    returning resource_service.new(params[resource_name]) do |comment|
      comment.user = current_user if logged_in?
    end
  end

end
