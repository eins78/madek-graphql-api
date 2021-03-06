describe 'getCollection' do
  before(:each) do
    set_collection
  end

  let(:collection_keys) { %w(id url metaData childMediaEntries) }
  let(:media_entry_keys) { %w(id url metaData mediaFile) }
  let(:media_file_keys) { %w(previews) }
  let(:preview_keys) { %w(id url contentType mediaType sizeClass) }
  let(:meta_data_keys) { %w(id metaKey value) }
  let(:query) { QueriesHelpers::CollectionQuery.new.query }
  let(:variables) { { 'id' => @collection.id, 'mediaTypes' => 'IMAGE' } }
  let(:response_collection) { response_to_h(query, variables)['data']['set'] }
  let(:response_media_entry) { sample_node_of(response_collection['childMediaEntries']) }
  let(:response_media_file) { response_media_entry['mediaFile'] }
  let(:response_media_file_preview) { sample_node_of(response_media_file['previews']) }

  it 'loads collections by ID' do
    expect(response_collection['id']).to eq(@collection.id)
    expect(response_collection.keys).to eq(collection_keys)
  end

  it "returns collections' media entries as relay connection" do
    expect(response_media_entry.keys).to eq(media_entry_keys)
  end

  it 'returns collection with only publicly visible media entries' do
    media_entries = @collection.media_entries
    media_entries.last.update(get_metadata_and_previews:false)

    expect(response_collection['childMediaEntries']['edges'].size).
      to eq(@collection.media_entries.public_visible.size)
  end

  it "returns media file for each media entry" do
    expect(response_media_file.keys).to eq(%w(previews))
  end

  it "returns media file's previews as relay connection" do
    expect(response_media_file_preview.keys).to eq(preview_keys)
  end

  it 'returns meta data for collection and media entries as relay connection' do
    expect(sample_node_of(response_collection['metaData']).keys).
      to eq(meta_data_keys)
    expect(sample_node_of(response_collection['metaData'])['metaKey']['id']).
      to be
    expect(sample_node_of(response_collection['metaData'])['value']['string']).
      to be
    expect(sample_node_of(response_media_entry['metaData']).keys).
      to eq(meta_data_keys)
    expect(sample_node_of(response_media_entry['metaData'])['metaKey']['id']).
      to be
    expect(sample_node_of(response_media_entry['metaData'])['value']['string']).
      to be
  end


  def set_collection
    @collection = FactoryGirl.create(:collection, get_metadata_and_previews: true)
    FactoryGirl.create(:meta_datum_title_with_collection, collection: @collection)
    fill_collection_with_media_entries_with_images(@collection, 4)
    add_meta_data_titles_to_collection_media_entries(@collection)
  end
end
