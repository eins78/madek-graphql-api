require 'rails_helper'

describe Types::MediaEntryType do

  context 'type definition' do

    subject { Types::MediaEntryType }

    it 'defines a field id of String type' do
      expect(subject).to have_field(:id).that_returns(type('String'))
    end

    it 'defines a field created_at of String type' do
      expect(subject).to have_field(:createdAt).that_returns(type('ISO8601DateTime'))
    end

    it 'defines a field title of String type' do
      expect(subject).to have_field(:id).that_returns(type('String'))
    end
  end


  def type(type)
    "GraphQL::Types::#{type}"
  end
end
