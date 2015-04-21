class CatsController < ApplicationController
  before_action :redirect_unless_cat_owner!, only: [:update, :edit]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = find_cat_by_id
    render :show
  end

  def new
    @cat = Cat.new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id

    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:error] = 'Bad cat parameters'
      render :new
    end
  end

  def edit
    @cat = find_cat_by_id
  end

  def update
    @cat = find_cat_by_id

    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:error] = 'Bad cat parameters'
      render :edit
    end
  end

  def destroy
    @cat = Cat.find(params[:id])
    @cat.destroy
    redirect_to cats_url
  end

  private

  def cat_params
    params.require(:cat).permit(:name, :birth_date, :gender, :color, :description)
  end

  def find_cat_by_id
    Cat.find(params[:id])
  end
end
