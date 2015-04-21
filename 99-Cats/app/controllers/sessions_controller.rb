class SessionsController < ApplicationController
  before_action :redirect_current_user, only: [:new, :create]

  def new
    @user = User.new
    @hide_login_button = true
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:user_name],
                                     params[:user][:password])

    if @user.nil?
      @hide_login_button = true
      flash[:error] = "Wrong Credentials"
      redirect_to new_session_url
    else
      login!(@user)
      flash[:success] = "Login successful"
      redirect_to cats_url
    end
  end

  def destroy
    logout!
    session[:session_token] = nil
    redirect_to new_session_url
  end

end
