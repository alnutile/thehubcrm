require 'linkedin'
require 'open-uri'
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
	  	#sync or use existing
	  	linked_in_data
	  	@count = LinkedInSetting.first.total_count
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
	    @connections = client.connections
	  end

	  private 
	    def linked_in_data
	    	if LinkedInSetting.first.present? 
				@connections = Person.all 
	    	else
		    	client = LinkedIn::Client.new(ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'])
			    if session[:atoken].nil?
			      pin = params[:oauth_verifier]
			      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
			      session[:atoken] = atoken
			      session[:asecret] = asecret
			    else
			      client.authorize_from_access(session[:atoken], session[:asecret])
			    end
			    save_connections(client.connections)
			    @connections = Person.all
			end
	    end

	    def save_connections(connections)
	    	Person.delete_all
	    	connections.all.each do |c|
	    		if c.picture_url.present?
	    		  path = File.join("public/linkedin_images", "#{c.id}.jpeg")
				  File.open(path, "wb") { |f| f.write(open(c.picture_url).read) }
				  image = c.id
			    else
			      image = ''
			    end
	    		Person.create!(
	    			:first_name => c.first_name,
	    			:last_name => c.last_name,
	    			:image => image,
	    			:network_id => c.id,
	    		);
	    	end
	    	LinkedInSetting.create!(
	    		:synced_last => Time.now(),
	    		:total_count => connections._count
	    	)
	    	@connections = Person.all
	    end
end
