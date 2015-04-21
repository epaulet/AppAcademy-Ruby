class GoalsController < ApplicationController
  before_action :find_by_id_and_ensure_author, only: [:show, :edit, :update, :destroy]

  def index
    @goals = Goal.where("goals.user_id = #{current_user.id} OR goals.is_private = false")
  end

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user_id = current_user.id

    if @goal.save
      redirect_to goals_url
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def show
  end

  def edit
  end

  def destroy
    @goal.destroy

    redirect_to goals_url
  end

  def update
    if @goal.update(goal_params)
      redirect_to goals_url
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :edit
    end
  end

  def find_by_id_and_ensure_author
    @goal = Goal.find_by_id(params[:id])

    redirect_to goals_url unless current_user.id == @goal.user_id
  end

  private

  def goal_params
    params.require(:goal).permit(:body, :is_private)
  end
end
