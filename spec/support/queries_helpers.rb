module QueriesHelpers
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
