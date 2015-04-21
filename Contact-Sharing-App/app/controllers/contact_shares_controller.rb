class ContactSharesController < ApplicationController
  def create
    @contact_share = ContactShare.new(contact_share_params)

    if @contact_share.save
      render json: @contact_share
    else
      render @contact_share.errors.full_messages
    end
  end

  def destroy
    @contact_share = ContactShare.find(params[:id])

    render json: @contact_share
    @contact_share.destroy

  end

  private

  def contact_share_params
    params.require(:contact_share).permit(:contact_id, :user_id)
  end
end
