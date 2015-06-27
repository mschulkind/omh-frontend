module Omh
  class Client
    API_VERSION="1.0.M1"

    attr_accessor :access_token

    def initialize(options={})
      @auth_base_url = options[:auth_base_url] || Omh.auth_base_url
      @resource_base_url = options[:resource_base_url] || Omh.resource_base_url
      @client_id = options[:client_id] || ENV['OMH_CLIENT_ID']
      @client_secret = options[:client_secret] || ENV['OMH_CLIENT_SECRET']
      unless @client_id && @client_secret
        raise "client_id or client_secret missing"
      end

      if options[:username] && options[:password]
        log_in(options[:username], options[:password])
      end
    end

    def log_in(username, password)
      response = auth.post(
        'oauth/token',
        username: username, password: password,
        grant_type: 'password')

      case response.status
      when 200
      when 400
        raise Omh::Error::AuthorizationError.new(response.body, response.status)
      else handle_error(response)
      end

      @access_token = response.body['access_token']
      response.body
    end

    def create_data_point(data_point)
      response = resource.post('dataPoints', data_point)

      case response.status
      when 201
      when 409
        raise Omh::Error::DataPointDuplicateError.new(
          response.body, response.status)
      else handle_error(response)
      end

      response.body
    end

    def get_data_point(id)
      response = resource.get("dataPoints/#{id}")

      case response.status
      when 200
      when 404
        raise Omh::Error::DataPointNotFoundError.new(
          response.body, response.status)
      else handle_error(response)
      end

      response.body
    end

    def get_data_points(options)
      response = resource.get("dataPoints", options)

      case response.status
      when 200
      else handle_error(response)
      end

      response.body
    end

    def delete_data_point(id)
      response = resource.delete("dataPoints/#{id}")

      case response.status
      when 200
      when 404
        raise Omh::Error::DataPointNotFoundError.new(
          response.body, response.status)
      else handle_error(response)
      end

      response.body
    end

   private

    def handle_error(response)
      case response.status
      when 401
        raise Omh::Error::AuthorizationError.new(response.body, response.status)
      else raise Omh::Error::OmhApiError.new(response.body, response.status)
      end
    end

    def faraday(&block)
      Faraday.new do |f|
        block.(f) if block_given?
        f.adapter Faraday.default_adapter
        f.response :json
      end
    end

    def auth
      faraday do |f|
        f.request :url_encoded
        f.url_prefix = @auth_base_url
        f.basic_auth(@client_id, @client_secret)
      end
    end

    def resource
      raise Omh::Error::AuthorizationError unless @access_token

      faraday do |f|
        f.request :json
        f.authorization(:Bearer, @access_token)
        f.url_prefix = @resource_base_url + "/v#{API_VERSION}"
      end
    end
  end
end
