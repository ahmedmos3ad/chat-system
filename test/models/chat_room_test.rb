require "test_helper"

class ChatRoomTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
