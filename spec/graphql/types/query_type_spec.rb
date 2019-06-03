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
        let(:query) { media_entry_query(media_entry.id) }
        let(:response_data) { response_as_hash(query)[:data][:mediaEntry] }

        it 'contains id' do
          expect(response_data[:id]).to eq(media_entry.id)
        end

        it 'contains createdAt in ISO 8601 standard' do
          standarized_created_at = media_entry.created_at.iso8601
          expect(response_data[:createdAt]).to eq(standarized_created_at)
        end

        it 'contains title' do
          expect(response_data[:title]).to eq(media_entry.title)
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
          let(:response_data) { response_as_hash(query)[:data][:allMediaEntries] }
          let(:stringified_created_ats) { MediaEntry.order('created_at DESC').
                                          first(100).
                                          pluck(:created_at).
                                          map(&:to_s) }

          it 'contains first 100 MediaEntries ordered by CREATED_AT_DESC' do
            expect(stringified_created_ats_from_response(response_data)).
              to eq(stringified_created_ats)
          end
        end

        context 'for query with arguments' do
          let(:query) { media_entries_query(first: 11,
                                            order_by: 'CREATED_AT_ASC') }
          let(:response_data) { response_as_hash(query)[:data][:allMediaEntries] }
          let(:stringified_created_ats) { MediaEntry.order('created_at ASC').
                                          first(11).
                                          pluck(:created_at).
                                          map(&:to_s) }

          it 'contains specified number of media entries in specified order' do
            expect(stringified_created_ats_from_response(response_data)).
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
        let(:collection) { FactoryGirl.create(:collection,
                                               sorting: 'created_at DESC') }
        let(:first) { 2 }
        let(:query) { collection_query(collection.id, first: first) }
        let(:response_data) { response_as_hash(query)[:data][:collection] }

        it 'contains id' do
          expect(response_data[:id]).to eq(collection.id)
        end

        it 'contains getMetadataAndPreviews' do
          expect(response_data[:getMetadataAndPreviews]).
            to eq(collection.get_metadata_and_previews)
        end

        it 'contains createdAt and updatedAr in ISO 8601 standard' do
          standarized_created_at = collection.created_at.iso8601
          standarized_updated_at = collection.updated_at.iso8601
          expect(response_data[:createdAt]).to eq(standarized_created_at)
          expect(response_data[:updatedAt]).to eq(standarized_updated_at)
        end

        it 'contains layout' do
          expect(response_data[:layout]).to eq(collection.layout)
        end

        it 'contains sorting' do
          expect(response_data[:sorting]).to eq(collection.sorting)
        end

        it 'contains responsibleUserId' do
          expect(response_data[:responsibleUserId]).
            to eq(collection.responsible_user_id)
        end

        #todo
        # add one more variable for response_data[:mediaEntries][:edges]
        # to shorten code below

        it 'contains first n MediaEntries from collection as edges - an array of nodes' do
          fill_collection_with_media_entries(collection)

          edges = response_data[:mediaEntries][:edges]
          node_key = edges.map(&:keys).flatten.uniq
          ids = edges.map { |n| n[:node][:id] }

          expect(node_key).to eq(["node"])
          expect(response_data[:mediaEntries][:edges].length).to eq(first)
          expect(ids).to eq(collection.media_entries.take(2).pluck(:id))
        end

        it 'contains first n MediaEntries after cursor' do
          fill_collection_with_media_entries(collection)

          query = collection_query(
            collection.id,
            first: first,
            cursor: response_data[:mediaEntries][:pageInfo][:endCursor])
          response_data = response_as_hash(query)[:data][:collection]
          ids = response_data[:mediaEntries][:edges].map { |n| n[:node][:id] }

          expect(response_data[:mediaEntries][:edges].length).to eq(first)
          expect(ids).to eq(collection.media_entries.offset(2).take(2).pluck(:id))
        end

        it 'contains MediaEntries ordered as speficied in query' do
          fill_collection_with_media_entries(collection)

          query = collection_query(
            collection.id,
            first: collection.media_entries.length,
            order_by: 'CREATED_AT_ASC')
          response_data = response_as_hash(query)[:data][:collection]

          ids = response_data[:mediaEntries][:edges].map { |n| n[:node][:id] }
          ordered_media_entries = collection.media_entries.order('created_at ASC')

          expect(ids).to eq(ordered_media_entries.ids)
        end

        it 'contains pageInfo for mediaEntries collection' do
          expect(response_data[:mediaEntries][:pageInfo].keys).
            to eq(%w(endCursor startCursor hasPreviousPage hasNextPage))
        end
      end
    end

    def fill_collection_with_media_entries(collection)
      collection.media_entries = FactoryGirl.create_list(:media_entry_with_title,
                                                          4)
    end

    def stringified_created_ats_from_response(response)
      response.map do |media_entry|
        ActiveSupport::TimeZone['UTC'].parse(media_entry[:createdAt]).to_s
      end
    end

   # todo 
   # move queries to helper

    def media_entry_query(id)
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

    def collection_query(id, first: 2, cursor: nil, order_by: nil)
      <<-GRAPHQL
        {
          collection(id: "#{id}") {
            id
            getMetadataAndPreviews
            createdAt
            updatedAt
            layout
            sorting
            responsibleUserId
            mediaEntries(first: #{first}
                         #{', after: ' if cursor} #{cursor}
                         #{', orderBy: ' if order_by} #{order_by}) {
              pageInfo {
                endCursor
                startCursor
                hasPreviousPage
                hasNextPage
              }
              edges {
                node {
                  id
                  createdAt
                  title
                }
              }
            }
          }
        }
      GRAPHQL

    end

    def media_entries_query(first: nil, order_by: nil)
      first = "first: #{first}" if first
      order_by = "orderBy: #{order_by}" if order_by
      params = [first, order_by].join(', ')

      <<-GRAPHQL
        {
          allMediaEntries(#{params}) {
            id
            createdAt
            title
          }
        }
      GRAPHQL
    end

    def response_as_hash(query)
      MadekGraphqlSchema.execute(query).to_h.with_indifferent_access
    end
  end
end
