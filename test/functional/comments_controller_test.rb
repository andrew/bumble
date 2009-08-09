require File.dirname(__FILE__) + '/../test_helper'

class CommentsControllerTest < ActionController::TestCase

  def setup
    @comment = Factory.create(:comment)
  end
  
  should_route :get,    "posts/1/comments",         :post_id => '1', :controller => :comments, :action => :index
  should_route :get,    "posts/1/comments/new",     :post_id => '1', :action => :new
  should_route :post,   "posts/1/comments",         :post_id => '1', :action => :create
  should_route :get,    "posts/1/comments/1",       :post_id => '1', :action => :show,    :id => '1'
  should_route :get,    "posts/1/comments/1/edit",  :post_id => '1', :action => :edit,    :id => '1'
  should_route :put,    "posts/1/comments/1",       :post_id => '1', :action => :update,  :id => '1'
  should_route :delete, "posts/1/comments/1",       :post_id => '1', :action => :destroy, :id => '1'

  context "logged in" do
    setup do
      activate_authlogic
      UserSession.create(Factory.create(:user))
    end

    context "on GET to :show for first record" do
      setup do
       get :show, :id => @comment.id, :post_id => @comment.post.id
      end

      should_redirect_to('the comments post') { post_url(@comment.post.to_param, :anchor => dom_id(@comment))}
      should_not_set_the_flash
    end

    context "on GET to :new" do
      setup do
        get :new, :post_id => @comment.post.id
      end

      should_assign_to :comment
      should_respond_with :success
      should_render_template :new
      should_not_set_the_flash
    end

    context "on GET to :index" do
      setup do
       get :index, :post_id => @comment.post.to_param
      end

      should_redirect_to('the comments post') { post_url(@comment.post.to_param, :anchor => 'comments')}
      should_not_set_the_flash
    end

    context "on POST to :create" do
      setup do
        @old_count = Comment.count
        post :create, :comment => Factory.attributes_for(:comment), :post_id => @comment.post.id
      end

      should "create a new comment" do
        assert_equal @old_count + 1, Comment.count
      end

      should_assign_to :comment
      should_set_the_flash_to 'Create successful!'
      should_redirect_to('the comments post') { post_url(@comment.post.to_param, :anchor => dom_id(assigns(:comment)))}
    end

    context "on GET to :edit for first record" do
      setup do
       get :edit, :id => @comment.id, :post_id => @comment.post.id
      end

      should_assign_to :comment
      should_respond_with :success
      should_render_template :edit
      should_not_set_the_flash
    end

    context "on PUT to :update" do
      setup do
        put :update, :id => @comment.id, :post_id => @comment.post.id, :comment => {}
      end

      should_assign_to :comment
      should_set_the_flash_to 'Save successful!'
      should_redirect_to('the comments post') { post_url(@comment.post.to_param, :anchor => dom_id(@comment))}
    end

    context "on DELETE to :destroy" do
      setup do
        @old_count = Comment.count
        delete :destroy, :id => @comment.id, :post_id => @comment.post.id
      end

      should "destroy comment" do
        assert_equal @old_count - 1, Comment.count
      end

      should_set_the_flash_to 'Record deleted!'
      should_redirect_to('the comments post') { post_url(@comment.post.to_param)}
    end
  end
  
  context "not logged in" do
    context "on GET to :show for first record" do
      setup do
       get :show, :id => @comment.id, :post_id => @comment.post.id
      end

      should_redirect_to('the comments post') { post_url(@comment.post.to_param, :anchor => dom_id(@comment))}
      should_not_set_the_flash
    end

    context "on GET to :new" do
      setup do
        get :new, :post_id => @comment.post.id
      end

      should_assign_to :comment
      should_respond_with :success
      should_render_template :new
      should_not_set_the_flash
    end

    context "on GET to :index" do
      setup do
       get :index, :post_id => @comment.post.id
      end

      should_redirect_to('the comments post') { post_url(@comment.post.to_param, :anchor => 'comments')}
      should_not_set_the_flash
    end

    context "on POST to :create" do
      setup do
        @old_count = Comment.count
        post :create, :comment => Factory.attributes_for(:comment, :author_name => 'David', :author_email => 'dave@example.com'), :post_id => @comment.post.id
      end

      should "create a new comment" do
        assert_equal @old_count + 1, Comment.count
      end

      should_assign_to :comment
      should_set_the_flash_to 'Create successful!'
      should_redirect_to('the comments post') { post_url(@comment.post.to_param, :anchor => dom_id(assigns(:comment)))}
    end

    context "on GET to :edit for first record" do
      setup do
       get :edit, :id => @comment.id, :post_id => @comment.post.id
      end

      should_be_denied_access
    end

    context "on PUT to :update" do
      setup do
        put :update, :id => @comment.id, :post_id => @comment.post.id, :comment => {}
      end

      should_be_denied_access
    end

    context "on DELETE to :destroy" do
      setup do
        @old_count = Comment.count
        delete :destroy, :id => @comment.id, :post_id => @comment.post.id
      end

      should "not destroy comment" do
        assert_equal @old_count, Comment.count
      end

      should_be_denied_access
    end
  end
end
