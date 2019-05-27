class MadekGraphqlSchema < GraphQL::Schema
  # see https://rmosolgo.github.io/blog/2019/01/29/a-new-runtime-in-graphql-ruby-1-dot-9/
  use GraphQL::Execution::Interpreter
  # use GraphQL::Analysis::AST

  # mutation(Types::MutationType)
  OrderByEnum = GraphQL::EnumType.define do
    name 'OrderByEnum'
    description 'Paremeter for ordering resources'

    value 'CREATED_AT_DESC', value: 'created_at DESC'
    value 'CREATED_AT_ASC', value: 'created_at ASC'
  end

  query(Types::QueryType)



end
