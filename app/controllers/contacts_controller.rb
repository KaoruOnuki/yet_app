class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :destroy]
  before_action :redirect_if_not_logged_in
  before_action :set_user

  def index
    @contacts = Contact.all
  end

  def show
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.user_id = current_user.id
    if @contact.name.empty?
      @contact.name = current_user.name
    end

    if @contact.email.empty?
      @contact.email = current_user.email
    end

    if @contact.save
      ContactMailer.contact_mail(@contact).deliver
      redirect_to @contact, notice: 'お問い合わせを送信しました'
    else
      render :new
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_url, notice: '削除しました'
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :content)
  end
end
