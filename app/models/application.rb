# frozen_string_literal: true

class Application < ApplicationRecord
  # has_many :chats

  validates :name, presence: true, length: {maximum: 255}
  validates :token, presence: true, uniqueness: true, length: {is: 36}
  validates :chats_count, numericality: {only_integer: true}
end

# == Schema Information
#
# Table name: applications
#
#  id          :bigint           not null, primary key
#  chats_count :integer          default(0)
#  name        :string(255)
#  token       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_applications_on_token  (token) UNIQUE
#
