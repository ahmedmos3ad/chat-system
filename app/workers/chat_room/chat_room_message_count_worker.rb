# frozen_string_literal: true

class ChatRoom::ChatRoomMessageCountWorker
  include Sidekiq::Worker
  sidekiq_options queue: :low

  def perform
    rooms_to_update_ids = RedisFacade.instance.fetch_and_clear_set_for_key(RedisFacade::CHAT_ROOMS_WITH_NEW_MESSAGES_KEY)
    ChatRoom.where(id: rooms_to_update_ids).update_all("messages_count = (SELECT COUNT(*) FROM chat_messages WHERE chat_messages.chat_room_id = chat_rooms.id)") if rooms_to_update_ids.present?
    self.class.perform_in(30.minutes)
  end
end