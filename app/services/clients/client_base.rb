module Clients
  class ClientBase
    include HTTParty

    def get(path, options={})
      with_error_handling do
        self.class.get(path, options)
      end
    end

    private

    def with_error_handling
      response = yield

      error_message = err_message(response)
      fetch_response(
        status_code: response.code,
        msg: error_message,
        response: response 
      )
    rescue Net::OpenTimeout
      raise TimeoutError
    end

    def fetch_response(status_code:, msg:, response:)
      case status_code
      when 400
        raise Errors::BadRequestError, msg
      when 401
        raise Errors::UnauthorizedRequestError, msg
      when 500
        raise Errors::InternalServerError, msg
      else
        response
      end
    end

    def err_message(response)
      response_type = response.header.content_type
      return response_error_message(response) if response_type == 'application/json'

      response.body
    end

    def response_error_message(response)
      response[:error]
    end
  end
end
