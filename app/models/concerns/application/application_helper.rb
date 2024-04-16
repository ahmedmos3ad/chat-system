# frozen_string_literal: true

module Application::ApplicationHelper
  extend ActiveSupport::Concern

  def generate_token
    logger.info("Generating token for application: #{name}")
    self.token = SecureRandom.uuid while token.blank? || self.class.exists?(token: token)
  end
end
