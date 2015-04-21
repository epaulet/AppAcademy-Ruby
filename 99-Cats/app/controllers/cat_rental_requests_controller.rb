class CatRentalRequestsController < ApplicationController
  before_action :redirect_unless_cat_owner!, only: [:approve, :deny]

  def new
    @request = CatRentalRequest.new
    @cats = Cat.all
  end

  def create
    @request = CatRentalRequest.new(cat_request_params)
    @cats = Cat.all
    @request.user_id = current_user.id if current_user

    if @request.save
      flash[:success] = "Cat request was successful."
      redirect_to cat_url(@request.cat_id)
    else
      flash.now[:error] = "Bad request parameters."
      render :new
    end
  end

  def approve
    @request = CatRentalRequest.find(cat_request_id)

    @request.approve!
    redirect_to cat_url(Cat.find(@request.cat_id))
  end

  def deny
    @request = CatRentalRequest.find(cat_request_id)

    @request.deny!
    redirect_to cat_url(Cat.find(@request.cat_id))
  end

  private

  def cat_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

  def cat_request_id
    params.require(:cat_rental_request).permit(:id)[:id]
  end
end
