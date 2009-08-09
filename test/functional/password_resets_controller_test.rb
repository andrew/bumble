require File.dirname(__FILE__) + '/../test_helper'

class PasswordResetsControllerTest < ActionController::TestCase
  def setup
    @user = Factory.create(:user)
  end
  
  should_route :get,  "/password_resets",                     :controller => :password_resets, :action => :index
  should_route :get,  "/password_resets/new",                 :action => :new
  should_route :post, "/password_resets",                     :action => :create
  should_route :get,  "/password_resets/1234567abcdefg/edit", :action => :edit,    :id => '1234567abcdefg'
  should_route :put,  "/password_resets/1234567abcdefg",      :action => :update,  :id => '1234567abcdefg'

  context "on GET to :new" do
    setup do
      get :new
    end

    should_respond_with :success
    should_render_template :new
    should_not_set_the_flash
  end

  context "on POST to :create" do
    setup do
      post :create, :email => @user.email
    end

    should_assign_to :user
    should_set_the_flash_to "Instructions to reset your password have been emailed to you. Please check your email."
    should_redirect_to('the created password_reset') { root_url}
  end

  context "a user who has requested a password reset" do
    setup do
      @user = Factory.create(:user)
      @user.deliver_password_reset_instructions!
    end

    context "on GET to :edit for first record" do
      setup do
       get :edit, :id => @user.perishable_token
      end

      should_assign_to :user
      should_respond_with :success
      should_render_template :edit
      should_not_set_the_flash
    end

    context "on PUT to :update" do
      setup do
        put :update, :id => @user.perishable_token, :user => {}
      end

      should_assign_to :user
      should_set_the_flash_to "Password successfully updated"
      should_redirect_to('the updated password_reset') { root_path}
    end
  end
end
