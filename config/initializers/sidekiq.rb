require 'sidekiq/api'

Sidekiq.configure_server do |config|
  config.redis = {url: ENV['REDIS_URL'] || "redis://localhost:6379/0"}
  config.on(:startup) do
    Application::ApplicationChatCountWorker.perform_in(30.minutes) unless job_scheduled?("Application::ApplicationChatCountWorker")
    ChatRoom::ChatRoomMessageCountWorker.perform_in(30.minute) unless job_scheduled?("ChatRoom::ChatRoomMessageCountWorker")
  end
end

Sidekiq.configure_client do |config|
  config.redis = {url: ENV['REDIS_URL'] || "redis://localhost:6379/0"}
end

def job_scheduled?(worker_class)
  scheduled_jobs = Sidekiq::ScheduledSet.new
  scheduled_jobs.any? { |job| job.klass == worker_class.to_s }
end
