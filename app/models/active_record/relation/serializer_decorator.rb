# frozen_string_literal: true

module ActiveRecord::Relation::SerializerDecorator
  def default_serializer_name
    klass.name
  end

  def as_serialized_json(options: {}, version: "V1", serializer_name: default_serializer_name)
    logger.debug "Serializing #{self.class} using <API::#{version}::#{serializer_name}Serializer>"
    map { |record| record.serialize_record(options, version, serializer_name) }
  end
end

ActiveRecord::Relation.include ActiveRecord::Relation::SerializerDecorator if ActiveRecord::Relation.included_modules.exclude?(ActiveRecord::Relation::SerializerDecorator)
