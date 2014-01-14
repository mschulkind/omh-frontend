module Omh
  module Error
    class LogInRequiredError < StandardError; end

    class OmhApiError < StandardError
      attr_accessor :status

      def initialize(message, status)
        @status = status
        super(message)
      end
    end

    class AuthorizationError < OmhApiError; end
  end
end
