class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

 private

  def omh
    options = {}
    options[:access_token] = session[:access_token] if session[:access_token]
    @omh ||= Omh::Client.new(options)
  end
end
