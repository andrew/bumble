class UsersController < BumbleController
  before_filter :require_user, :except => [:activate]

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def index
    @users = User.paginate(:page => params[:page])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = "User Deleted"
        redirect_to users_path
      end
    end
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    if @user.save
      flash[:notice] = 'User updated successfully'
      redirect_to posts_path
    else
      render :action => 'edit'
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions!
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_to login_path
    else
      render :action => :new
    end
  end

  def activate
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    if @user.activate!
      @user.deliver_activation_confirmation!
      flash[:notice] = "Your account has been activated."
      UserSession.create(@user)
      redirect_to root_path
    else
      render :action => :new
    end
  end
end
