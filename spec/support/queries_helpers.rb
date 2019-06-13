module QueriesHelpers
  def media_entry_query
    "query getMediaEntry($id: ID!) {
       mediaEntry(id: $id) {
         id
         createdAt
         title
       }
     }"
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

  class CollectionQuery
    def initialize(depth = 1)
      @depth = depth
    end

    def query
      "query getCollection($id: ID!, $first: Int, $cursor: String, $orderBy: OrderByEnum) {
        collection(id: $id) {
          #{subqueries}
        }
      }"
    end

    def subqueries
      "#{collection_attributes}
       #{media_entries}
       #{collections if @depth > 0}"
    end

    def collection_attributes
      "id
       getMetadataAndPreviews
       createdAt
       updatedAt
       layout
       sorting
       responsibleUserId"
    end

    def media_entries
      "mediaEntries(first: $first, after: $cursor, orderBy: $orderBy) {
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
       }"
    end

    def collections
       "collections(first: $first, after: $cursor, orderBy: $orderBy) {
         pageInfo {
           endCursor
           startCursor
           hasPreviousPage
           hasNextPage
         }
         edges {
           node {
             #{CollectionQuery.new(@depth - 1).subqueries}
           }
         }
       }"
    end
  end
end
