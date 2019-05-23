describe Types::QueryType do

  describe 'MediaEntryType fields' do

    describe Types::QueryType.fields['mediaEntry'] do

      it 'requires and "id" argument of ID type' do
        id_argument = subject.arguments['id']

        expect(id_argument.type.class).to be(GraphQL::Schema::NonNull)
        expect(id_argument.type.of_type).to be(GraphQL::Types::ID)
      end
    end
  end
end
