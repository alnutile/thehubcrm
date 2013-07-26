require 'linkedin'
class AuthController < ApplicationController
	def index
	    # get your api keys at https://www.linkedin.com/secure/developer
	    #client = LinkedIn::Client.new("your_api_key", "your_secret")
	    client = LinkedIn::Client.new(ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'])
	    request_token = client.request_token(:oauth_callback =>
	                                      "http://#{request.host_with_port}/auth/callback")
	    session[:rtoken] = request_token.token
	    session[:rsecret] = request_token.secret

	    redirect_to client.request_token.authorize_url

	  end
	  def show 
	  	client = LinkedIn::Client.new(ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'])
	    logger.info("Client #{client.to_s}")
	    if session[:atoken].nil?
	      pin = params[:oauth_verifier]
	      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
	      session[:atoken] = atoken
	      session[:asecret] = asecret
	    else
	      client.authorize_from_access(session[:atoken], session[:asecret])
	    end
	    @profile = client.profile
	    @connections = client.connections
	    @note = Note.new
	  end

	  def callback
	    client = LinkedIn::Client.new(ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'])
	    logger.info("Client #{client.to_s}")
	    if session[:atoken].nil?
	      pin = params[:oauth_verifier]
	      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
	      session[:atoken] = atoken
	      session[:asecret] = asecret
	    else
	      client.authorize_from_access(session[:atoken], session[:asecret])
	    end
	    @profile = client.profile
	    @connections = client.connections
	    @jobs = client.job_bookmarks
	  end
end
