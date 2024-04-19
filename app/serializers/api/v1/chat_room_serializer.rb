# frozen_string_literal: true

class API::V1::ChatRoomSerializer < API::V1::BaseSerializer
  attributes :number, :messages_count, :created_at, :updated_at
end