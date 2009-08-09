class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def create
    if @user = User.find_by_email(params[:email])
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you. Please check your email."
      redirect_to root_path
    else
      flash[:notice] = "No user was found with that email address"
      render :action => :new
    end
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = "Password successfully updated"
      redirect_to root_url
    else
      render :action => :edit
    end
  end

  private

  def load_user_using_perishable_token
    unless @user = User.find_using_perishable_token(params[:id])
      flash[:notice] = "We're sorry, but we could not locate your account. "
      redirect_to password_resets_path
    end
  end
end
