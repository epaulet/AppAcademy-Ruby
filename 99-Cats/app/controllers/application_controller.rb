class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :belongs_to_current_user?

  def login!(user)
    @current_user = user
    session[:session_token] = Session.create_session(user.id).session_token
  end

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by_session_token(session[:session_token])
  end

  def belongs_to_current_user?(cat)
    current_user.id == cat.user_id
  end

  def redirect_current_user
    redirect_to cats_url unless current_user.nil?
  end

  def redirect_unless_cat_owner!
    @cat = Cat.find(params[:id])
    redirect_to cats_url unless @cat.user_id == current_user.id
  end

  def logout!
    current_session = Session.find_by_session_token(session[:session_token])
    current_session.destroy
  end
end
