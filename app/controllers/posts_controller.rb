class PostsController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :search, :sitemap]

  make_resourceful do
    actions :all

    before :show do
      fresh_when(:etag => [current_object, current_object.comments]) unless current_user
    end

    response_for :destroy do |format|
      format.html do
        flash[:notice] = "Record deleted!"
        redirect_to posts_path
      end
      format.js { render :nothing => true }
    end
  end

  def index
    respond_to do |format|
      format.html do
        @posts = Post.paginate  :page => params[:page],
                                :order => 'published_at DESC',
                                :per_page => per_page
        fresh_when(:etag => [@posts, Comment.last]) unless current_user
      end
      format.atom do
        @posts = Post.find(:all,
                           :order => 'published_at DESC',
                           :limit => 50)
      end
    end
  end

  def create
    build_object
    load_object
    current_object.user = current_user
    if params[:commit] == "Preview"
      current_object.valid?
      respond_to do |format|
        format.js { render :partial => 'preview', :locals => {:post => current_object}, :content_type => :html }
        format.html do
          flash[:notice] = 'Create successful!'
          redirect_to posts_path
        end
      end
    else
      if current_object.save
        respond_to do |format|
          format.js { render :partial => 'post', :locals => {:post => current_object}, :content_type => :html }
          format.html do
            flash[:notice] = 'Create successful!'
            redirect_to post_path(current_object)
          end
        end
      else
        respond_to do |format|
          format.js   { render :text => current_object.errors.full_messages.join(', ').capitalize, :status => 403, :content_type => :html }
          format.html { render :action => "new" }
        end
      end
    end
  end

  def search
    @posts = current_model.search(params[:query]).paginate  :page => params[:page],
                                                            :order => 'published_at DESC',
                                                            :per_page => per_page
    respond_to do |format|
      format.html
      format.atom { render :action => :index}
    end
  end

  def sitemap
    expires_in 1.hour, :public => true
    Sitemap::Routes.parse
    respond_to do |format|
      format.xml do
        render :xml => Sitemap::Routes.results.to_xml
      end
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

  def current_model_name
    params.include?(Post.types.map(&:downcase)) || controller_name.singularize.camelize
  end

  def current_model
    current_user ? super : Post.published.all_public
  end

  def current_object
    @current_object ||= current_model.find_by_permalink_or_id(params[:id])
  end
end
