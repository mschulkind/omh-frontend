module Omh
  DEFAULT_AUTH_BASE_URL='http://localhost:8082/'
  DEFAULT_RESOURCE_BASE_URL='http://localhost:8083/'

  def self.auth_base_url
    ENV['OMH_AUTH_BASE_URL'] || DEFAULT_AUTH_BASE_URL
  end

  def self.resource_base_url
    ENV['OMH_RESROUCE_BASE_URL'] || DEFAULT_RESOURCE_BASE_URL
  end
end
