module Omh
  module Error
    class AuthorizationRequiredError < StandardError; end

    class OmhApiError < StandardError
      attr_accessor :status

      def initialize(message, status)
        @status = status
        super(message)
      end
    end

    class AuthorizationError < OmhApiError; end
    class UserDuplicateError < OmhApiError; end
    class DataPointDuplicateError < OmhApiError; end
    class DataPointNotFoundError < OmhApiError; end
  end
end
