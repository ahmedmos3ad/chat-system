# frozen_string_literal: true

module ChatMessage::ChatMessageHelper
  extend ActiveSupport::Concern

  def add_chat_room_to_chat_rooms_with_new_messages_set
    RedisFacade.instance.add_entry_to_set(chat_room_id, RedisFacade::CHAT_ROOMS_WITH_NEW_MESSAGES_KEY)
  end
end