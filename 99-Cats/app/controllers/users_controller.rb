class UsersController < ApplicationController
  before_action :redirect_current_user, only: [:new, :create]

  def new
    @user = User.new
    @hide_signup_button = true
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      redirect_to cats_url
    else
      @hide_signup_button = true
      flash.now[:error] = @user.errors.full_messages
      render :new
    end
  end


  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
