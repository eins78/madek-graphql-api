describe Types::QueryType do

  describe 'MediaEntryType fields' do

    describe Types::QueryType.fields['mediaEntry'] do

      context 'field definition' do

        it 'requires and "id" argument of ID type' do
          id_arg = subject.arguments['id']

          expect(id_arg.type.class).to be(GraphQL::Schema::NonNull)
          expect(id_arg.type.of_type).to be(GraphQL::Types::ID)
        end
      end

      context 'response' do

        let(:media_entry) { FactoryGirl.create(:media_entry_with_title) }
        let(:query) { media_entry_query(media_entry.id) }
        let(:response_data) { response_data_as_hash(query)[:mediaEntry] }

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
      end
    end


    describe Types::QueryType.fields['allMediaEntries'] do
      context 'field definition' do
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
          let(:response_data) { response_data_as_hash(query)[:allMediaEntries] }
          let(:stringified_created_ats) { MediaEntry.order('created_at DESC').
                                          first(100).
                                          pluck(:created_at).
                                          map(&:to_s) }

          it 'returns first 100 MediaEntries ordered by CREATED_AT_DESC' do
            expect(stringified_created_ats_from_response(response_data)).
              to eq(stringified_created_ats)
          end
        end

        context 'for query with arguments' do
          let(:query) { media_entries_query(first: 11,
                                            order_by: 'CREATED_AT_ASC') }
          let(:response_data) { response_data_as_hash(query)[:allMediaEntries] }
          let(:stringified_created_ats) { MediaEntry.order('created_at ASC').
                                          first(11).
                                          pluck(:created_at).
                                          map(&:to_s) }

          it 'returns specified number of media entries in specified order' do
            expect(stringified_created_ats_from_response(response_data)).
              to eq(stringified_created_ats)
          end
        end
      end
    end


    def stringified_created_ats_from_response(response)
      response.map do |media_entry|
        ActiveSupport::TimeZone['UTC'].parse(media_entry[:createdAt]).to_s
      end
    end

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

    def response_data_as_hash(query)
      MadekGraphqlSchema.execute(query).to_h.deep_symbolize_keys[:data]
    end
  end
end
