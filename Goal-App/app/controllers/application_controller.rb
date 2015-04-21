class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :require_login

  def login_user!
    session[:session_token] = @user.get_session_token
    @user.save
  end

  def current_user
    User.find_by_session_token(session[:session_token])
  end

  def require_login
    redirect_to new_session_url unless current_user
  end
end
