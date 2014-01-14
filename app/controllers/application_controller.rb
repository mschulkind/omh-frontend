class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

 private

  def omh
    options = {}
    
    if session[:username] && session[:password]
      options[:username] = session[:username]
      options[:password] = 
        AES.decrypt(session[:password], Rails.configuration.secret_base_key)
    end

    @omh ||= Omh::Client.new(options)
  end
end
