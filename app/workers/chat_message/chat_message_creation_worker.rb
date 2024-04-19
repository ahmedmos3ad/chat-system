# frozen_string_literal: true

class ChatMessage::ChatMessageCreationWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: :default

  def perform(chat_room_id, chat_message_number, body)
    ChatMessage.create!(chat_room_id: chat_room_id, number: chat_message_number, body: body)
  end
end