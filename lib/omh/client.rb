module Omh
  class Client
    def initialize(options={})
      @base_url = options[:base_url] || ENV['OMH_BASE_URL']
      raise 'base_url required' unless @base_url

      @base_url += '/v1/'

      if options[:username] && options[:password]
        log_in(options[:username], options[:password])
      end
    end

    def log_in(username, password)
      @auth_token = 
        faraday.post('auth', username: username, password: password).body
    end

    def create_user(username, password)
      faraday.post(
        'users/registration',
        username: username,
        password: password,
        email: 'email@not.used')
    end

   private

    class FaradayErrors < Faraday::Response::Middleware
      def on_complete(env)
        case env[:status]
        when 200
        when 401 then raise Omh::Error::AuthorizationError, env[:body]
        else raise Omh::Error::OmhApiError.new(env[:body], env[:status]) 
        end
      end
    end

    def faraday
      Faraday.new(url: @base_url) do |f|
        f.request :url_encoded
        f.adapter Faraday.default_adapter

        f.use FaradayErrors
      end
    end
  end
end
