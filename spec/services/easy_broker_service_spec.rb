require 'rails_helper'

RSpec.describe EasyBrokerService, type: :service do
  let(:eb_service) { described_class.new }
  let(:eb_client) { instance_double(Clients::EasyBrokerClient) }

  before do
    allow(Clients::EasyBrokerClient).to receive(:new).and_return(eb_client)
  end

  describe '#fetch_all_properties_titles' do
    it 'fetches all property titles' do
      allow(eb_client).to receive(:list_properties).and_return({
        pagination: { next_page: nil },
        content: [{ title: 'Property 1' }, { title: 'Property 2' }]
      })

      titles = eb_service.fetch_all_properties_titles
      expect(titles).to eq(['Property 1', 'Property 2'])
    end

    it 'returns an empty array if no properties are returned' do
      allow(eb_client).to receive(:list_properties).and_return({
        pagination: { next_page: nil },
        content: []
      })

      titles = eb_service.fetch_all_properties_titles

      expect(titles).to eq([])
    end
  end

  describe '#fetch_properties_titles_per_page' do
    it 'fetches property titles for a given page' do
      allow(eb_client).to receive(:list_properties).and_return({
        pagination: { next_page: nil },
        content: [{ title: 'Property 1' }, { title: 'Property 2' }, { title: 'Property 3' }]
      })

      titles = eb_service.fetch_properties_titles_per_page(1)

      expect(titles).to eq(['Property 1', 'Property 2', 'Property 3'])
    end
  end
end
