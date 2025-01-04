module Errors
  class BadRequestError < StandardError; end
  class UnauthorizedRequestError < StandardError; end
  class InternalServerError < StandardError; end
end
