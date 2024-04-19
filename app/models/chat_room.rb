# frozen_string_literal: true

class ChatRoom < ApplicationRecord
  include ChatRoom::ChatRoomHelper
  
  belongs_to :application
  has_many :chat_messages, dependent: :destroy

  validates :number, presence: true, uniqueness: { scope: :application_id }

  after_create :add_application_to_application_with_new_chat_room_set
end

# == Schema Information
#
# Table name: chat_rooms
#
#  id             :bigint           not null, primary key
#  messages_count :integer          default(0), not null
#  number         :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  application_id :bigint           not null
#
# Indexes
#
#  index_chat_rooms_on_application_id             (application_id)
#  index_chat_rooms_on_application_id_and_number  (application_id,number) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (application_id => applications.id)
#
