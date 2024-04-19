# frozen_string_literal: true

class ChatRoom::ChatRoomMessageCountWorker
  include Sidekiq::Worker
  sidekiq_options queue: :low

  def perform
    apps_to_update_ids = RedisFacade.instance.fetch_and_clear_set_for_key(RedisFacade::CHAT_ROOMS_WITH_NEW_MESSAGES_KEY)
    Application.where(id: apps_to_update_ids).update_all(chats_count: "SELECT COUNT(*) FROM chat_rooms WHERE chat_rooms.application_id = applications.id") if apps_to_update_ids.present?
    self.class.perform_in(30.minutes)
  end
end