class UsersController < ApplicationController
  before_action :init_errors
  after_action :collect_errors

  def create
    require_username_and_password

    unless params[:password_confirmation].present?
      @errors << "Password confirmation must not be blank."
    end
    if @errors.empty? && params[:password] != params[:password_confirmation]
      @errors << "Password and confirmation did not match."
    end

    unless @errors.present?
      begin
        omh.create_user(params[:username], params[:password])
        flash[:notice] = "User successfully registered."
      rescue Omh::Error::UserDuplicateError => e
        @errors << "Duplicate user."
      rescue Omh::Error::OmhApiError => e
        @errors << "Server error (#{e.status}): #{e}."
      end
    end

    redirect_to '/'
  end

  def log_in
    require_username_and_password

    unless @errors.present?
      begin
        response = omh.log_in(params[:username], params[:password])
        session[:access_token] = response['access_token']
        flash[:notice] = "Successfully logged in."
      rescue Omh::Error::AuthorizationError => e
        @errors << "Invalid username or password."
      end
    end

    redirect_to '/'
  end

  def log_out
    session[:access_token] = nil
    flash[:notice] = "Logged out."
    redirect_to '/'
  end

 private

  def init_errors
    @errors = []
  end

  def collect_errors
    flash[:alert] = @errors.join('<br>') unless @errors.empty?
  end

  def require_username_and_password
    unless params[:username].present?
      @errors << "Username must not be blank."
    end
    unless params[:password].present?
      @errors << "Password must not be blank."
    end
  end
end
