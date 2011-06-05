class CommentsController < BumbleController

  before_filter :require_user, :only => [:edit, :update, :destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    @comment.request = request
    @comment.post = @post

    if @comment.save
      respond_to do |format|
        format.html do
          if @comment.approved?
            flash[:notice] = 'Create successful!'
          else
            flash[:notice] = "Your comment looks like spam, it will show up once it's been approved."
          end
          redirect_to post_path(@post, :anchor => dom_id(@comment))
        end
        format.js do
          if @comment.approved?
            render @comment, :content_type => :html
          else
            render :text => "Your comment looks like spam, it will show up once it's been approved.", :status => 406, :content_type => :html
          end
        end
      end
    else
      respond_to do |format|
        format.html { render :action => "new" }
        format.js   { render :text => @comment.errors.full_messages.join(', ').capitalize, :status => 403, :content_type => :html }
      end
    end
  end
  
  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments
    respond_to do |format|
      format.html { redirect_to post_path(@post, :anchor => 'comments') }
      format.atom {}
      format.js { render @comments }
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = 'Record deleted!'
        redirect_to post_path(@comment.post)
      end
      format.js { render :nothing => true }
    end
  end
  
  def update
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      respond_to do |format|
        format.html do
          flash[:notice] = 'Save successful!'
          redirect_to post_path(@post, :anchor => dom_id(@comment))
        end
      end
    else
      render :action => 'edit'
    end
  end
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  def new
    @comment = Comment.new
  end

  def show
    @comment = Comment.find(params[:id])
    redirect_to post_path(@comment.post, :anchor => dom_id(@comment))
  end

  def approve
    @comment = Comment.find(params[:id])
    @comment.mark_as_ham!
    redirect_to post_path(@comment.post, :anchor => dom_id(@comment))
  end

  def reject
    @comment = Comment.find(params[:id])
    @comment.mark_as_spam!
    redirect_to post_path(@comment.post, :anchor => dom_id(@comment))
  end
end
