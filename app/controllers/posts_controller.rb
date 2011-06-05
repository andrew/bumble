class PostsController < BumbleController
  before_filter :require_user, :except => [:index, :show, :search, :sitemap]

  def new
    @post = build_object
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = "Record deleted!"
        redirect_to posts_path
      end
      format.js { render :nothing => true }
    end
  end

  def show
    @post = current_model.find_by_permalink_or_id(params[:id])
    fresh_when(:etag => [@post, @post.comments]) unless current_user
  end

  def index
    respond_to do |format|
      format.html do
        @posts = current_model.paginate  :page => params[:page],
                                :order => 'published_at DESC',
                                :per_page => per_page
        fresh_when(:etag => [@posts, Comment.last]) unless current_user
      end
      format.atom do
        @posts = current_model.find(:all,
                           :order => 'published_at DESC',
                           :limit => 50)
      end
    end
  end

  def create
    build_object
    @post.user = current_user
    if params[:commit] == "Preview"
      @post.valid?
      respond_to do |format|
        format.js { render :partial => 'preview', :locals => {:post => @post}, :content_type => :html }
        format.html do
          flash[:notice] = 'Create successful!'
          redirect_to posts_path
        end
      end
    else
      if @post.save
        respond_to do |format|
          format.js { render :partial => 'post', :locals => {:post => @post}, :content_type => :html }
          format.html do
            flash[:notice] = 'Create successful!'
            redirect_to post_path(@post)
          end
        end
      else
        respond_to do |format|
          format.js   { render :text => @post.errors.full_messages.join(', ').capitalize, :status => 403, :content_type => :html }
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

  private

  def build_object
    Post.types.each do |t|
      if params.include?(t.downcase)
        @post = Object.const_get(t).new(params[t.downcase])
      end
    end
    @post ||= Blog.new
  end

  def per_page
    (iphone? ? 5 : 10)
  end

  def current_model_name
    params.include?(Post.types.map(&:downcase)) || controller_name.singularize.camelize
  end

  def current_model
    current_user ? Post.scoped : Post.published.all_public
  end
end
