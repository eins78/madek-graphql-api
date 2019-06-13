module CollectionsHelpers
  def fill_collection_with_nested_collections(collection, depth)
    depth.times do
      collection.collections << FactoryGirl.create(:collection)
      collection = collection.collections.last
    end
  end

  def fill_collection_with_media_entries(collection)
    collection.media_entries = FactoryGirl.create_list(:media_entry_with_title,
                                                        4)
  end
end
