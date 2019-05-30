module Types
  class MediaEntryType < Types::BaseObject
    field :id, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :title, String, null: true
  end
end
