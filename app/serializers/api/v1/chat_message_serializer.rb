# frozen_string_literal: true

class API::V1::ChatMessageSerializer < API::V1::BaseSerializer
  attributes :number, :body, :created_at, :updated_at
end