class ApplicationController < ActionController::Base

  helper :all
  protect_from_forgery

  filter_parameter_logging :password, :password_confirmation

  helper_method :current_user_session, :current_user, :iphone?

  private

  def iphone?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    access_denied('You must be logged in to do that!') unless current_user
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def access_denied(message = 'Access Denied')
    if request.xhr?
      render :text => message, :status => :unauthorized
    else
      store_location
      flash[:error] = message
      redirect_to login_path
    end
    return false
  end

  def redirect_back_or_default(default = root_path)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
