describe Types::CollectionType do

  context 'type definition' do

    subject { Types::CollectionType }

    { id: 'String',
      getMetadataAndPreviews: 'Boolean',
      createdAt: 'ISO8601DateTime',
      updatedAt: 'ISO8601DateTime',
      layout: 'String',
      sorting: 'String',
      responsibleUserId: 'String' }.each do |field, type|

      it "defines a field #{field} of #{type} type" do
        expect(subject).to have_field(field).that_returns(type(type))
      end
    end

    it 'also defines a field mediaEntries that is a connection' do
      expect(subject.fields['mediaEntries'].connection?).to be(true)
    end
  end
end
