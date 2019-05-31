describe Types::MediaEntryType do

  context 'type definition' do

    subject { Types::MediaEntryType }

    { id: 'String',
      title: 'String',
      createdAt: 'ISO8601DateTime' }.each do |field, type|

      it "defines a field #{field} of #{type} type" do
        expect(subject).to have_field(field).that_returns(type(type))
      end
    end
  end


  def type(type)
    "GraphQL::Types::#{type}"
  end
end
