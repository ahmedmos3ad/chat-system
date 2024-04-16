# frozen_string_literal: true

require Rails.root.join("app/models/active_record/relation/serializer_decorator")
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def default_serializer_name
    self.class.name
  end

  def as_serialized_json(options: {}, version: "V1", serializer_name: default_serializer_name)
    logger.debug "Serializing #{self.class.name} ##{id} using <API::#{version}::#{serializer_name}Serializer>"
    serialize_record(options, version, serializer_name)
  end

  def serialize_record(options, version, serializer_name)
    "API::#{version}::#{serializer_name}Serializer".constantize.new(self, options).serializable_hash[:data][:attributes]
  end

  def logger
    ConsoleLogger.instance.logger
  end
end
