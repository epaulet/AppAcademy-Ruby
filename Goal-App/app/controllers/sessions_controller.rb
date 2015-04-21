class SessionsController < ApplicationController
  skip_before_action :require_login, except: :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(params[:user][:username], params[:user][:password])

    if @user
      login_user!
      redirect_to goals_url
    else
      flash[:errors] = ["Bad username or password"]
      redirect_to new_session_url
    end
  end

  def destroy
    user = current_user
    user.get_session_token
    user.save

    session[:session_token] = nil
    redirect_to new_session_url
  end

end
