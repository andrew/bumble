class SessionsController < ApplicationController

  def create
    if @user = (User.find_by_login(params[:login]) or User.find_by_email(params[:login]))
      self.current_user = User.authenticate(@user.login, params[:password])
      handle_login
    else
      flash[:notice] = "Incorrent Login"
      redirect_to :action => 'new'
    end
  end

  def destroy
    logout
  end
  
  private
  
  def handle_login 
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      current_user.last_login = Time.now
      current_user.save
      flash[:notice] = "Logged in successfully"
      redirect_back_or_default(root_path)
    else
      unless @user.active?
        flash[:notice] = "Your account has not yet been activated, please check your email"
      else  
        flash[:notice] = "Incorrect Password"
      end
      redirect_to :action => 'new'
    end
  end
  
end
