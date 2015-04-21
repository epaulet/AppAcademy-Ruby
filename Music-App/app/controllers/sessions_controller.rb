class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_credentials(params[:user][:email],
                                     params[:user][:password])
    if @user.nil?
      flash[:errors] = 'Email and/or password were incorrect.'
      redirect_to new_session_url
    else
      login!(@user)
      redirect_to user_url(@user)
    end
  end

  def destroy
    logout_current_user!

    redirect_to new_session_url
  end
end
