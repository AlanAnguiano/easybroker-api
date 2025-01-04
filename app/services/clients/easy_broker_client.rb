module Clients
  class EasyBrokerClient < Clients::ClientBase
    base_uri Rails.application.credentials.easy_broker_api_base_uri
    parser ->(response_body, _fmt) { Oj.load(response_body, symbol_keys: true) if response_body.present? }
    headers 'X-Authorization' => Rails.application.credentials.easy_broker_api_key,
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'

    def list_properties(page: 1)
      get('/properties', query: pagination_query(page))
    end

    private

    def pagination_query(page)
      {
        page: page,
        limit: 50
      }
    end
  end
end
