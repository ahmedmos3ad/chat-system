# frozen_string_literal: true

module Application::ApplicationHelper
  extend ActiveSupport::Concern

  def max_chat_number_cache_key
    "applications:{#{id}}:max_chat_number"
  end

  private

  def generate_token
    logger.info("Generating token for application: #{name}")
    self.token = SecureRandom.uuid while token.blank? || self.class.exists?(token: token)
  end
end
