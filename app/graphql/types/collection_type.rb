module Types
  class CollectionType < Types::BaseObject

    field :id, String, null: true
    field :get_metadata_and_previews, Boolean, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: true
    field :layout, String, null: true
    field :sorting, String, null: true
    field :responsible_user_id, String, null: true
    field :media_entries,
           MediaEntryType.connection_type,
           null: true,
           connection: true do
             argument :orderBy, MadekGraphqlSchema::OrderByEnum, required: false
           end


   def media_entries(order_by: nil)
     object.media_entries.order(order_by)
   end
  end
end
