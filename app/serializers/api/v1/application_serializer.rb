# frozen_string_literal: true

class API::V1::ApplicationSerializer < API::V1::BaseSerializer
  attributes :token, :name, :created_at, :updated_at
end
