module Types
  class MediaFileType < Types::BaseObject
    field :previews,
      PreviewType.connection_type,
           null: true,
           connection: true do
             argument :media_types,
                       MadekGraphqlSchema::PreviewMediaTypesEnum,
                       required: false
           end
  end
end
