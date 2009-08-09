class CommentsController < ApplicationController

  before_filter :require_user, :only => [:edit, :update, :destroy]

  make_resourceful do
    actions :all
    belongs_to :post
    before :create do
      current_object.user = current_user
    end

    response_for :index do |format|
      format.html { redirect_to post_path(parent_object, :anchor => 'comments') }
      format.atom {}
      format.js { render current_objects }
    end

    response_for :show do |format|
      format.html { redirect_to post_path(parent_object, :anchor => dom_id(current_object)) }
    end

    response_for :destroy do |format|
      format.html do
        flash[:notice] = 'Record deleted!'
        redirect_to post_path(parent_object)
      end
    end

    response_for :update do |format|
      format.html do
        flash[:notice] = 'Save successful!'
        redirect_to post_path(parent_object, :anchor => dom_id(current_object))
      end
    end

    response_for :create do |format|
      format.html do
        flash[:notice] = 'Create successful!'
        redirect_to post_path(parent_object, :anchor => dom_id(current_object))
      end
      format.js { render current_object }
    end

    response_for :create_fails do |format|
      format.html { render :action => "new" }
      format.js   { render :text => current_object.errors.full_messages.join(', ').capitalize, :status => 403 }
    end

    response_for :destroy do |format|
      format.html do
        flash[:notice] = 'Record deleted!'
        redirect_to post_path(current_object.post)
      end
      format.js { render :nothing => true }
    end
  end

  private

  def parent_model
    current_user ? super : Post.published.all_public
  end

  def parent_object
    @parent_object ||= parent_model.find_by_permalink_or_id(params["#{parent_name}_id"])
  end
end