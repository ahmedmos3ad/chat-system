class ChatMessage < ApplicationRecord
  include ChatMessage::ChatMessageHelper

  attr_accessor :skip_number_validation

  belongs_to :chat_room

  validates :body, presence: true
  validates :number, presence: true, uniqueness: { scope: :chat_room_id }, unless: -> { skip_number_validation }

  after_create :add_chat_room_to_chat_rooms_with_new_messages_set
end

# == Schema Information
#
# Table name: chat_messages
#
#  id           :bigint           not null, primary key
#  body         :text(65535)      not null
#  number       :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chat_room_id :bigint           not null
#
# Indexes
#
#  index_chat_messages_on_chat_room_id             (chat_room_id)
#  index_chat_messages_on_chat_room_id_and_number  (chat_room_id,number) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (chat_room_id => chat_rooms.id)
#
