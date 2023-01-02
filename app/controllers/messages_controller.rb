class MessagesController < ApplicationController
  def create
    @message  = Message.new(message_params)
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message.chatroom = @chatroom
    @message.user = current_user
    if @message.save
      # redirect_to chatroom_path(@chatroom)
      ChatroomChannel.broadcast_to(@chatroom,
        render_to_string(partial: 'messages/message', locals: { message: @message })
      )
      head :ok
    else
      render 'chatrooms/show', status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
