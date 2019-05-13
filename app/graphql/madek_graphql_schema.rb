class MadekGraphqlSchema < GraphQL::Schema
  # see https://rmosolgo.github.io/blog/2019/01/29/a-new-runtime-in-graphql-ruby-1-dot-9/
  use GraphQL::Execution::Interpreter
  # use GraphQL::Analysis::AST

  # mutation(Types::MutationType)
  query(Types::QueryType)
end
