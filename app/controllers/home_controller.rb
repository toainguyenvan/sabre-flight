class HomeController < ApplicationController
	require 'rest-client'
	before_action :authenticate_user, only: :index
	layout 'login/home'

	def index
		"You are granted to access!"
	end

	def new
	end

	def sign_out
		current_user.token = ''
		current_user.save
		session[:current_user_id] = ''
		redirect_to sign_in_path
	end	

	def sign_in
		code, data, message = Authentication.get_token(params[:username], params[:password])
		if code == "200"
			# Check User
			user = User.find_by(token: data['access_token'])
			unless user.presence
				user = User.create(username: params[:username], password: params[:password], token: data['access_token'], token_created_at: Time.now)
			end

			if user.presence
				user.token = data['access_token']
				user.token_created_at = Time.now
				user.save
			elsif user.username == params[:username] and user.password == params[:password]
				# Old user, assign new token
				user.token = data["access_token"]
				user.token_created_at = Time.now
				user.save
			end

			# update session
			session[:current_user_id] = user.id
			redirect_to flight_search_path
		else
			render :new
		end
	end

  private

  def authenticate_user
  	if current_user
  		redirect_to flight_search_path
  	else
  		render :new
  	end
  	
  end

  def validate_token!

  	if headers['Authorization'].present? 
  		return headers['Authorization'].split(' ').last 
  	else 
  		# Does't have the token. Redirect to sign_in page
  		render :new, :notice => 'if you want to add a notice'
  	end
  end
	
end