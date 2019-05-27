module Types
  class QueryType < Types::BaseObject

    field :set,
           CollectionType,
           null: false,
           method: :itself do
      description 'Find a Collection by ID'
      argument :id, ID, required: true
      argument :orderBy,  MadekGraphqlSchema::OrderByEnum, required: false
    end

    field :all_media_entries, [Types::MediaEntryType], null: true do
      description 'Find all MediaEntries'
      argument :first, Int, required: false
      argument :orderBy, MadekGraphqlSchema::OrderByEnum, required: false
    end

    field :media_entry, MediaEntryType, null: true do
      description 'Find a MediaEntry by ID'
      argument :id, ID, required: true
    end

    def set(id:)
      collection = Collection.find(id)
      PublicPermissionCheck.for(collection)
      collection
    end

    def media_entry(id:)
      MediaEntry.find(id)
    end

    def all_media_entries(first: 100, order_by: 'created_at DESC', limit: 1000)
      MediaEntry.order(order_by).first(first)#.limit(limit)
    end
  end
end

