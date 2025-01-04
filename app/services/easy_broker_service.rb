class EasyBrokerService
  def fetch_all_properties_titles
    fetching_log
    retrieve_all_properties_titles
  end

  def fetch_properties_titles_per_page(page)
    properties = retrieve_property_per_page(page: page)
    extract_property_titles(properties[:content])
  end

  private

  def retrieve_property_per_page(page: 1)
    eb_client.list_properties(page: page)
  end

  def retrieve_all_properties_titles
    page = 1
    property_titles = []
    loop do
      response = retrieve_property_per_page(page: page)
      properties = response[:content]

      property_titles.concat(extract_property_titles(properties)) if properties.present?

      break if response[:pagination][:next_page] == nil
      page += 1
    end

    property_titles
  end

  def extract_property_titles(properties)
    properties.map{ |property| property[:title] }
  end

  def eb_client
    @eb_client ||= Clients::EasyBrokerClient.new
  end

  def fetching_log
    Rails.logger.info('Fetching Properties Titles...')
  end
end
