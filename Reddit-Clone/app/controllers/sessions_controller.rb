class SessionsController < ApplicationController

  def new
    redirect_to user_url(current_user) if logged_in?
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if !@user.nil?
      login_user(@user)
      redirect_to subs_url
    else
      flash[:errors] = "Bad Credentials"
      redirect_to new_session_url
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end
end
