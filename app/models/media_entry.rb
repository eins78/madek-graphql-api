class MediaEntry < ApplicationRecord
  has_many :collection_media_entry_arcs,
            class_name: 'Arcs::CollectionMediaEntryArc'
  has_many :parent_collections,
            through: :collection_media_entry_arcs,
            source: :collection

  # has_one :media_file

  has_many :meta_data

  include Concerns::Users::Creator
  include Concerns::Users::Responsible

  scope :public_visible, -> { where(get_metadata_and_previews: true) }
  scope :published, -> { where(is_published: true) }
  default_scope { published.public_visible }

  def title
    meta_data.where(meta_key_id: 'madek_core:title').take.string
  end
end
