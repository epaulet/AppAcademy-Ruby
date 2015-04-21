class ContactsController < ApplicationController
  def index
    @contacts = User.find(params[:user_id]).contacts
    @shared_contacts = User.find(params[:user_id]).shared_contacts
    render json: @contacts + @shared_contacts
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      render json: @contact
    else
      render @contact.errors.full_messages
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    render json: @contact
    @contact.destroy
  end

  def show
    @contact = Contact.find(params[:id])
    render json: @contact
  end

  def update
    @contact = Contact.find(params[:id])

    if @contact.update(contact_params)
      render json: @contact
    else
      render @contact.errors.full_messages
    end
  end

private
  def contact_params
    params.require(:contact).permit(:name, :email, :user_id)
  end
end
