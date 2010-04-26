class PostsController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :search]

  make_resourceful do
    actions :all

    response_for :index do |format|
      format.html
      format.atom
    end

    response_for :destroy do |format|
      format.html do
        flash[:notice] = "Record deleted!"
        redirect_to posts_path
      end
      format.js { render :nothing => true }
    end
  end

  def create
    build_object
    load_object
    current_object.user = current_user
    if params[:commit] == "Preview"
      current_object.valid?
      respond_to do |format|
        format.js { render :partial => 'preview', :locals => {:post => current_object} }
        format.html do
          flash[:notice] = 'Create successful!'
          redirect_to posts_path
        end
      end
    else
      if current_object.save
        respond_to do |format|
          format.js { render :partial => 'post', :locals => {:post => current_object} }
          format.html do
            flash[:notice] = 'Create successful!'
            redirect_to post_path(current_object)
          end
        end
      else
        respond_to do |format|
          format.js   { render :text => current_object.errors.full_messages.join(', ').capitalize, :status => 403 }
          format.html { render :action => "new" }
        end
      end
    end
  end

  def search
    @posts = current_model.search(params[:query], :page => params[:page],
                                                  :order => 'published_at DESC',
                                                  :per_page => per_page)
    respond_to do |format|
      format.html
      format.atom { render :action => :index}
    end
  end

  private

  def build_object
    Post.types.each do |t|
      if params.include?(t.downcase)
        @current_object = Object.const_get(t).new(params[t.downcase])
      end
    end
    @current_object ||= Blog.new
  end

  def current_objects
    @current_object ||= current_model.paginate  :page => params[:page],
                                                :order => 'published_at DESC',
                                                :per_page => per_page
  end

  def per_page
    (iphone? ? 5 : 10)
  end

  def current_model
    current_user ? super : Post.published.all_public
  end

  def current_object
    @current_object ||= current_model.find_by_permalink_or_id(params[:id])
  end
end
