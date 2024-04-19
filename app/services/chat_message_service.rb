# frozen_string_literal: true

class ChatMessageService

  def initialize(chat_room, message_params)
    @chat_room = chat_room
    @message_params = message_params
  end

  def create_chat_message
    logger.info("Enqueuing chat message creation for chat_room:##{@chat_room.id}")
    chat_message = @chat_room.chat_messages.new(@message_params)
    chat_message.skip_number_validation = true
    chat_message.valid?
    if chat_message.errors.any?
      raise ActiveRecord::RecordInvalid.new(chat_message)
    end
    chat_message_number = RedisFacade.instance.incr(@chat_room.max_message_number_cache_key)
    ChatMessage::ChatMessageCreationWorker.perform_async(@chat_room.id, chat_message_number, @message_params[:body])
    chat_message.number = chat_message_number
    chat_message
  end
end