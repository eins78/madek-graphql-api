describe MadekGraphqlSchema do
  let(:current_defn) { MadekGraphqlSchema.to_definition }
  let(:printout_defn) { File.read(Rails.root.join("app/graphql/schema.graphql")) }

  it 'should be updated after any changes' do
    expect(current_defn).to eq(printout_defn), "Update the printed schema with `bundle exec rake dump_graphql_schema`"
  end
end
