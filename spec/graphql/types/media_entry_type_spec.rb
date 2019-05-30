describe Types::MediaEntryType do
  let(:media_entry) { FactoryGirl.create(:media_entry_with_title) }
  let(:response_data) { response_to_h[:data][:mediaEntry] }

  it 'returns id' do
    media_entry
    expect(response_data[:id]).to eq(media_entry.id)
  end

  it 'returns createdAt in ISO 8601 standard' do
    standarized_created_at = media_entry.created_at.iso8601
    expect(response_data[:createdAt]).to eq(standarized_created_at)
  end

  it 'returns title' do
    expect(response_data[:title]).to eq(media_entry.title)
  end



  def response_to_h
    query = get_media_entry_by_id(media_entry.id)
    MadekGraphqlSchema.execute(query).to_h.with_indifferent_access
  end

  def get_media_entry_by_id(id)
    <<-GRAPHQL
      {
        mediaEntry(id: "#{id}") {
          id
          createdAt
          title
        }
      }
    GRAPHQL
  end
end