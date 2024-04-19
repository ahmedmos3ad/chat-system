class Application::ApplicationChatCountWorker
  include Sidekiq::Worker
  sidekiq_options queue: :low

  def perform
    apps_to_update_ids = RedisFacade.instance.fetch_and_clear_set_for_key(RedisFacade::APPLICATIONS_WITH_NEW_CHAT_ROOMS_KEY)
    Application.where(id: apps_to_update_ids).update_all("chats_count = (SELECT COUNT(*) FROM chat_rooms WHERE chat_rooms.application_id = applications.id)") if apps_to_update_ids.present?
    self.class.perform_in(30.minutes)
  end
end