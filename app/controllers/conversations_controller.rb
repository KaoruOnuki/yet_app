class ConversationsController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_user

  def index
    @users = User.all
    @conversations = Conversation.all
  end

  def create
    if logged_in?
      if Conversation.between(params[:sender_id], params[:recipient_id]).present?
        @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
      else
        @conversation = Conversation.create!(conversation_params)
      end
      redirect_to conversation_messages_path(@conversation)
    else
      redirect_to conversations_path
    end
  end

  private

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
end
