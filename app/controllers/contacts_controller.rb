class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :your_contact, only: [:index, :new, :edit, :show]

  def index
    @contacts = Contact.all
  end

  def show
  end

  def new
    @contact = Contact.new
  end

  def edit
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
      Slack.chat_postMessage(text: '新しい本が作成されました！', username: 'Slack Bot', channel: '#test_kaoru2')
    else
      render :new
    end
  end

  def update
    @contact.user_id = current_user.id
    if @contact.update(contact_params)
      ContactMailer.contact_mail(@contact).deliver
      redirect_to @contact, notice: 'お問い合わせを再送信しました'
    else
      render :edit
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

  def your_contact
    redirect_to new_session_path if !logged_in?
  end

  # def notify_to_slack
  #   text = <<-EOC
  #   -----------------------------
  #     [#{Rails.env}] 新しいご意見が来ました。
  #
  #     ▼メールアドレス
  #     #{@contact.email}
  #     ▼内容
  #     #{@contact.content}
  #   EOC
  #   Slack.chat_postMessage text: text, username: "お問い合わせのお知らせ", channel: "#test_kaoru2"
  # end
end
