module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # First describe the field signature:
    field :media_entry, MediaEntryType, null: true do
      description "Find a MediaEntry by ID"
      argument :id, ID, required: true
    end

    # Then provide an implementation:
    def media_entry(id:)
      MediaEntry.find(id)
    end
  end
end
