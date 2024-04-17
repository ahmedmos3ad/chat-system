# frozen_string_literal: true

class Application < ApplicationRecord
  include Application::ApplicationHelper
  # has_many :chats, dependent: :destroy

  validates :name, presence: true, length: {maximum: 255}
  validates :token, presence: true, length: {is: 36}, if: :persisted? # skip validation for token on create because it will be generated
  validates :token, uniqueness: true, on: :update, if: :token_changed?
  validates :chats_count, numericality: {only_integer: true}

  # opted to not user before validation here on create to prevent unnecessary db queries when the model is invalid due to other validations
  before_create :generate_token
end

# == Schema Information
#
# Table name: applications
#
#  id          :bigint           not null, primary key
#  chats_count :integer          default(0), not null
#  name        :string(255)      not null
#  token       :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_applications_on_token  (token) UNIQUE
#
