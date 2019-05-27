module Types
  class MetaDataType < Types::BaseObject
    field :id, String, null: true
    field :metaKey, MetaKeyType, null: true
    field :value, ValueType, null: true
  end
end
