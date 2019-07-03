desc "Dump GraphQL schema to file"
task dump_graphql_schema: :environment do
  schema_path = "app/graphql/schema.graphql"
  schema_defn = MadekGraphqlSchema.to_definition
  File.write(Rails.root.join(schema_path), schema_defn)
  puts "Updated #{schema_path}"
end

task build_graphql_docs: :environment do
  BASE_URL = '/docs'
  options = {
    schema: MadekGraphqlSchema.to_definition,
    delete_output: true, # cleanup before building
    output_dir: Rails.root.join('public').join(".#{BASE_URL}"),
    base_url: BASE_URL
  }
  GraphQLDocs.build(options)
  puts "Built docs in #{options[:output_dir]}"
end
