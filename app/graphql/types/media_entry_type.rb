module Types
  class MediaEntryType < Types::BaseObject
    field :id, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :title, String, null: true

    def title
      MetaDatum.where(meta_key_id: 'madek_core:title',
                      media_entry_id: self.object.id).take.string
    end
  end
end
