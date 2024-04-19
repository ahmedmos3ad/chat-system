require "test_helper"

class ChatMessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
