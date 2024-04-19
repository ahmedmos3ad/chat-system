# frozen_string_literal: true

class ChatRoom::ChatRoomCreationWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: :critical

  def perform(application_id, chat_room_number)
    logger.info("ChatRoomCreationWorker::Creating chat room for application_id: #{application_id} with number: #{chat_room_number}")
    ChatRoom.create!(application_id: application_id, number: chat_room_number)
  end
end