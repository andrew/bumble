class ApplicationController < ActionController::Base
  helper :all

  protect_from_forgery
  
  include AuthenticatedSystem

  before_filter :login_from_cookie

  filter_parameter_logging :password
    
  helper_method :iphone_user_agent?
  def iphone_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
  end
  
  def logged_in_scope(klass = Post.scoped({}))
    logged_in? ? klass.scoped({}) : klass.all_public.published
  end
  
  def class_from_params(klass_name)
    begin
      Object.const_get(klass_name)
    rescue
      raise ActiveRecord::RecordNotFound, "Could not find Class with name: #{klass_name}"
    end
  end
  
  def access_denied(message = "Access Denied - Please Login")
    flash[:notice] = message
    store_location
    redirect_to login_path
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to root_path and return false
  end
  
end
