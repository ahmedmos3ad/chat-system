# frozen_string_literal: true

class ChatRoomService

  def initialize(application)
    @application = application
  end

  def create_chat_room
    logger.info("Enqueuing chat room creation for application:##{@application.id}")
    chat_room_number = RedisFacade.instance.incr(@application.max_chat_number_cache_key)
    ChatRoom::ChatRoomCreationWorker.perform_async(@application.id, chat_room_number)
    ChatRoom.new(application_id: @application.id, number: chat_room_number)
  end
end