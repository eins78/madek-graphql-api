describe Types::QueryType do

  context 'MediaEntryType' do

    subject { Types::MediaEntryType }

    it 'requires and "id" argument of ID type' do
      id_argument = Types::QueryType.fields['mediaEntry'].arguments['id']

      expect(id_argument.type.class).to be(GraphQL::Schema::NonNull)
      expect(id_argument.type.of_type).to be(GraphQL::Types::ID)
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
end
