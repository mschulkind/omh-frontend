class UsersController < ApplicationController
  def create 
    @errors = []

    unless params[:username].present?
      @errors << "Username must not be blank."
    end
    unless params[:password].present?
      @errors << "Password must not be blank."
    end
    unless params[:password_confirmation].present?
      @errors << "Password confirmation must not be blank."
    end
    if @errors.empty? && params[:password] != params[:password_confirmation]
      @errors << "Password and confirmation did not match."
    end

    if @errors.empty?
      begin
        omh.create_user(params[:username], params[:password])
      rescue Omh::Error::OmhApiError => e
        @errors << "Server error: #{e}"
      end
    end

    if @errors.empty?
      save_login_info
      redirect_to '/'
    else
      render :new
    end
  end

 private

  def save_login_info
    session[:username] = params[:username]
    session[:password] = 
      AES.encrypt(params[:password], Rails.configuration.secret_key_base)
  end
end
