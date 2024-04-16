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
require "test_helper"

class ApplicationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
