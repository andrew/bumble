class UserSessionsController < BumbleController
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new
    if @user_session.save
      flash[:notice] = 'Logged in successfully'
      redirect_back_or_default root_path
    else
      render :action => 'new'
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = 'Logged out successfully'
    redirect_to root_path
  end
end