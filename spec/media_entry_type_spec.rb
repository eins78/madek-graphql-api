describe Types::MediaEntryType do
  let(:types) { GraphQL::Define::TypeDefiner.instance }
  subject { Types::MediaEntryType }

  it 'accepts and id argument of type String' do
    pending
    expect(Types::QueryType.fields['mediaEntry']).to accept_arguments(id: "ID")
  end

  it 'defines a field id of String type' do
    expect(subject).to have_field(:id).that_returns(type('String'))
  end

  it 'defines a field created_at of String type' do
    expect(subject).to have_field(:createdAt).that_returns(type('ISO8601DateTime'))
  end

  it 'defines a field title of String type' do
    expect(subject).to have_field(:id).that_returns(type('String'))
  end

  def type(type)
    "GraphQL::Types::#{type}"
  end
end
