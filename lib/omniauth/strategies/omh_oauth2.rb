require 'omh'

module OmniAuth
  module Strategies
    class OmhOauth2 < OmniAuth::Strategies::OAuth2
      option :name, "omh_oauth2"

      option :client_options, {
        :site          => Omh.auth_base_url,
        :authorize_url => '/oauth/authorize',
        :token_url     => '/oauth/token'
      }
    end
  end
end
