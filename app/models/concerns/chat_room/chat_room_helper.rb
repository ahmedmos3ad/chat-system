# frozen_string_literal: true

module ChatRoom::ChatRoomHelper
  extend ActiveSupport::Concern

  def max_message_number_cache_key
    "applications:{#{id}}:max_message_number"
  end

  def add_application_to_application_with_new_chat_room_set
    RedisFacade.instance.add_entry_to_set(application_id, RedisFacade::APPLICATIONS_WITH_NEW_CHAT_ROOMS_KEY)
  end
end