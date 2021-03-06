class MessagesController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_user
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  def index
    @messages = @conversation.messages
    redirect_if_wrong_user_for_message
    if @messages.length > 5
      @over_five = true
      @messages = @messages[-5..-1]
    end

    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end

    if @messages.last
      if @messages.last.user_id != current_user.id
        @messages.last.read = true
      end
    end

    @message = @conversation.messages.build
  end

  def create
    @message = @conversation.messages.build(message_params)
    if @message.save
      redirect_to conversation_messages_path(@conversation)
    else
      render 'index'
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :user_id)
  end

  def redirect_if_wrong_user_for_message
    redirect_to new_session_path unless @conversation.sender_id == current_user.id || @conversation.recipient_id == current_user.id
  end
end
