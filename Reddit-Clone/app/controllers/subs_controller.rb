class SubsController < ApplicationController
  before_action :ensure_moderator, only: [:edit, :update]
  before_action :ensure_logged_in, only: [:new, :create]

  def index
    @subs = Sub.all
  end

  def show
    @sub = Sub.find(params[:id])
  end

  def new
    @sub = Sub.new(moderator_id: current_user.id)
  end

  def create
    @sub = Sub.new(sub_params)

    if @sub.save
      flash[:notice] = 'Sub successfully created!'
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit

  end

  def update
    if @sub.update(sub_params)
      flash[:notice] = 'Sub successfully updated!'
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  private

  def sub_params
    params.require(:sub).permit(:title, :description, :moderator_id)
  end

  def ensure_moderator
    @sub = Sub.find(params[:id])
    redirect_to subs_url unless @sub.is_moderator?(current_user)
  end
end
