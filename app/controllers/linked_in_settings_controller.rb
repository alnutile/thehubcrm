require 'linkedin'
require 'open-uri'
class LinkedInSettingsController < ApplicationController
  # GET /linked_in_settings
  # GET /linked_in_settings.json
  def index
    @linked_in_settings = LinkedInSetting.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @linked_in_settings }
    end
  end

  # GET /linked_in_settings/1
  # GET /linked_in_settings/1.json
  def show
    @linked_in_setting = LinkedInSetting.find(params[:id])
    if params[:sync]
      linked_in_settings = LinkedInSetting.first
      # @todo clean up sessions might not be really needed
      #   since now in db
      session[:atoken] = linked_in_settings.atoken
      session[:asecret] = linked_in_settings.asecret
      session[:rtoken] = linked_in_settings.rtoken
      session[:rsecret] = linked_in_settings.rsecret
      client = LinkedIn::Client.new(linked_in_settings.key, linked_in_settings.secret)
      client.authorize_from_access(linked_in_settings.atoken, linked_in_settings.asecret)
      @new_linked_in = client.connections
      logger.info("Connections: #{@new_linked_in._count}")
      linked_in_sync(@new_linked_in)
      linked_in_settings.update_attributes(:total_count => @new_linked_in.total )
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @linked_in_setting }
    end
  end

  # GET /linked_in_settings/new
  # GET /linked_in_settings/new.json
  def new
    @linked_in_setting = LinkedInSetting.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @linked_in_setting }
    end
  end

  # GET /linked_in_settings/1/edit
  def edit
    @linked_in_setting = LinkedInSetting.find(params[:id])
  end

  # POST /linked_in_settings
  # POST /linked_in_settings.json
  def create
    @linked_in_setting = LinkedInSetting.new(params[:linked_in_setting])

    respond_to do |format|
      if @linked_in_setting.save
        format.html { redirect_to @linked_in_setting, notice: 'Linked in setting was successfully created.' }
        format.json { render json: @linked_in_setting, status: :created, location: @linked_in_setting }
      else
        format.html { render action: "new" }
        format.json { render json: @linked_in_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /linked_in_settings/1
  # PUT /linked_in_settings/1.json
  def update
    @linked_in_setting = LinkedInSetting.find(params[:id])

    respond_to do |format|
      if @linked_in_setting.update_attributes(params[:linked_in_setting])
        format.html { redirect_to @linked_in_setting, notice: 'Linked in setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @linked_in_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def linked_in_sync(latest)
        latest.all.each do |c|
          find_contact = Person.find_by_network_id("#{c.id}").nil?
          if find_contact == true
            if c.picture_url.present?
              path = File.join("public/linkedin_images", "#{c.id}.jpeg")
              #File.open(path, "wb") { |f| f.write(open(c.picture_url).read) }
              #image = c.id
              image = '' #@todo see why the above fails
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
          end

  end

  # DELETE /linked_in_settings/1
  # DELETE /linked_in_settings/1.json
  def destroy
    @linked_in_setting = LinkedInSetting.find(params[:id])
    @linked_in_setting.destroy

    respond_to do |format|
      format.html { redirect_to linked_in_settings_url }
      format.json { head :no_content }
    end
  end
end
