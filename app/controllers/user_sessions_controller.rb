class UserSessionsController < ApplicationController
  make_resourceful do
    actions :new, :create

    response_for :create do |format|
      format.html do
        flash[:notice] = 'Logged in successfully'
        redirect_back_or_default root_path
      end
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = 'Logged out successfully'
    redirect_to root_path
  end
end