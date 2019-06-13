describe Types::QueryType do

  describe 'MediaEntryType fields' do

    describe Types::QueryType.fields['mediaEntry'] do

      context 'field' do

        it 'requires and "id" argument of ID type' do
          id_arg = subject.arguments['id']

          expect(id_arg.type.class).to be(GraphQL::Schema::NonNull)
          expect(id_arg.type.of_type).to be(GraphQL::Types::ID)
        end
      end

      context 'response' do

        let(:media_entry) { FactoryGirl.create(:media_entry_with_title) }
        let(:query) { media_entry_query }
        let(:variables) { { 'id' => media_entry.id } }
        let(:response) { response_data(query, variables)['mediaEntry'] }

        it 'contains id' do
          expect(response['id']).to eq(media_entry.id)
        end

        it 'contains createdAt in ISO 8601 standard' do
          standarized_created_at = media_entry.created_at.iso8601
          expect(response['createdAt']).to eq(standarized_created_at)
        end

        it 'contains title' do
          expect(response['title']).to eq(media_entry.title)
        end
      end
    end


    describe Types::QueryType.fields['allMediaEntries'] do
      context 'field' do
        let(:first_arg) { subject.arguments['first'] }
        let(:order_by_arg) { subject.arguments['orderBy'] }

        it 'does not require any arguments' do
          expect(first_arg.instance_variable_get(:@null)).to be(true)
          expect(order_by_arg.instance_variable_get(:@null)).to be(true)
        end

        it 'accepts "first" and "order_by" arguments of
            Int and MadekGraphqlSchema::OrderByEnum types respectively' do
          expect(first_arg.type).to be(GraphQL::Types::Int)
          expect(order_by_arg.type).to be(MadekGraphqlSchema::OrderByEnum)
        end
      end

      context 'response' do
        before(:all) do
          FactoryGirl.create_list(:media_entry_with_title, 101)
        end

        context 'for query with no arguments specified' do
          let(:query) { media_entries_query }
          let(:response) { response_data(query, nil)['allMediaEntries'] }
          let(:stringified_created_ats) { MediaEntry.order('created_at DESC').
                                          first(100).
                                          pluck(:created_at).
                                          map(&:to_s) }

          it 'contains first 100 MediaEntries ordered by CREATED_AT_DESC' do
            expect(stringified_created_ats_from_response(response)).
              to eq(stringified_created_ats)
          end
        end

        context 'for query with arguments' do
          let(:query) { media_entries_query(first: 11, order_by: 'CREATED_AT_ASC') }
          let(:response) { response_data(query, variables)['allMediaEntries'] }
          let(:stringified_created_ats) { MediaEntry.order('created_at ASC').
                                          first(11).
                                          pluck(:created_at).
                                          map(&:to_s) }

          it 'contains specified number of media entries in specified order' do
            expect(stringified_created_ats_from_response(response)).
              to eq(stringified_created_ats)
          end
        end
      end
    end


    describe Types::QueryType.fields['collection'] do
      context 'field' do
        it 'requires and "id" argument of ID type' do
          id_arg = subject.arguments['id']

          expect(id_arg.type.class).to be(GraphQL::Schema::NonNull)
          expect(id_arg.type.of_type).to be(GraphQL::Types::ID)
        end

        it 'accepts an "order_by" argument of
            MadekGraphqlSchema::OrderByEnum type for ordering media entries' do
          order_by_arg = subject.arguments['orderBy']
          expect(order_by_arg.type).to be(MadekGraphqlSchema::OrderByEnum)
        end
      end

      context 'response' do
        let(:collection) { FactoryGirl.create(:collection) }
        let(:collection_2) { FactoryGirl.create(:collection) }
        let(:first) { 2 }
        let(:query) { QueriesHelpers::CollectionQuery.new(0).query }
        let(:variables) { { 'id' => collection.id,
                            'first' => first,
                            'orderBy' => 'CREATED_AT_ASC' } }
        let(:response) { response_data(query, variables)['collection'] }

        it 'contains id' do
          expect(response['id']).to eq(collection.id)
        end

        it 'contains getMetadataAndPreviews' do
          expect(response['getMetadataAndPreviews']).
            to eq(collection.get_metadata_and_previews)
        end

        it 'contains createdAt and updatedAt in ISO 8601 standard' do
          standarized_created_at = collection.created_at.iso8601
          standarized_updated_at = collection.updated_at.iso8601
          expect(response['createdAt']).to eq(standarized_created_at)
          expect(response['updatedAt']).to eq(standarized_updated_at)
        end

        it 'contains layout' do
          expect(response['layout']).to eq(collection.layout)
        end

        it 'contains sorting' do
          expect(response['sorting']).to eq(collection.sorting)
        end

        it 'contains responsibleUserId' do
          expect(response['responsibleUserId']).
            to eq(collection.responsible_user_id)
        end

        it 'contains first n MediaEntries from collection as edges - an array of nodes' do
          fill_collection_with_media_entries(collection)

          edges = response['mediaEntries']['edges']
          node_key = edges.map(&:keys).flatten.uniq
          ids = edges.map { |n| n['node']['id'] }

          expect(node_key).to eq(['node'])
          expect(response['mediaEntries']['edges'].length).to eq(first)
          expect(ids).to eq(collection.media_entries.take(2).pluck(:id))
        end

        it 'contains first n MediaEntries after cursor' do
          fill_collection_with_media_entries(collection)

          query = QueriesHelpers::CollectionQuery.new(0).query
          variables = { 'id' => collection.id,
                        'first' => first,
                        'cursor' => response['mediaEntries']['pageInfo']['endCursor'] }
          response = response_data(query, variables)['collection']
          ids = response['mediaEntries']['edges'].map { |n| n['node']['id'] }

          expect(response['mediaEntries']['edges'].length).to eq(first)
          expect(ids).to eq(collection.media_entries.offset(2).take(2).pluck(:id))
        end

        it 'contains MediaEntries ordered as speficied in query' do
          fill_collection_with_media_entries(collection)

          query = QueriesHelpers::CollectionQuery.new(0).query
          variables = { 'id' => collection.id,
                       'first' => collection.media_entries.length,
                       'orderBy' => 'CREATED_AT_ASC' }
          response = response_data(query, variables)['collection']

          ids = response['mediaEntries']['edges'].map { |n| n['node']['id'] }
          ordered_media_entries = collection.media_entries.order('created_at ASC')

          expect(ids).to eq(ordered_media_entries.ids)
        end

        it 'contains pageInfo for mediaEntries collection' do
          expect(response['mediaEntries']['pageInfo'].keys).
            to eq(%w(endCursor startCursor hasPreviousPage hasNextPage))
        end

        it 'contains nested collections' do
          fill_collection_with_nested_collections(collection, 5)

          query = QueriesHelpers::CollectionQuery.new(5).query
          variables = { 'id' => collection.id }
          response = response_data(query, variables)['collection']

          expect(node_from_nested_connection(response, 'collections', 5)).to be
          expect(response.to_json.scan(/collections/).count).to eq(5)
        end
      end
    end
  end
end
