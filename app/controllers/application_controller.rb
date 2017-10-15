class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  attr_reader :current_user
  def current_user
  	@current_user ||= User.find_by(id: session[:current_user_id])
  end
end
