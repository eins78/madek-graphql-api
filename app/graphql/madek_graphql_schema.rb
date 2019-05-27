class MadekGraphqlSchema < GraphQL::Schema
  # see https://rmosolgo.github.io/blog/2019/01/29/a-new-runtime-in-graphql-ruby-1-dot-9/
  use GraphQL::Execution::Interpreter
  # use GraphQL::Analysis::AST

  max_depth 25
  middleware(GraphQL::Schema::TimeoutMiddleware.new(max_seconds: 2))

  OrderByEnum = GraphQL::EnumType.define do
    name 'OrderByEnum'
    description 'Paremeter for ordering resources'

    value 'CREATED_AT_DESC', value: 'created_at DESC'
    value 'CREATED_AT_ASC', value: 'created_at ASC'
  end

  MediaEntryMediaTypesEnum = GraphQL::EnumType.define do
    name 'MediaEntryMediaTypesEnum'
    description 'Media entry media type'

    description 'Media entry media types'
    value 'IMAGE', value: 'image'
  end

  PreviewMediaTypesEnum = GraphQL::EnumType.define do
    name 'PreviewMediaTypesEnum'
    description 'Preview media type'

    description 'Preview media types'
    value 'IMAGE', value: 'image'
  end

  PreviewSizeClassesEnum = GraphQL::EnumType.define do
    name 'PreviewSizeClassesEnum'
    description 'Preview size class'

    description 'Preview size class'
    value 'SMALL', value: 'small'
    value 'SMALL_125', value: 'small_125'
    value 'MEDIUM', value: 'medium'
    value 'LARGE', value: 'large'
    value 'X_LARGE', value: 'x_large'
    value 'MAXIMUM', value: 'maximum'
  end

  query(Types::QueryType)
end
