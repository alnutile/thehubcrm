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
