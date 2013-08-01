class LinkedInSetting < ActiveRecord::Base
  attr_accessible :key, :secret, :synced_last, :total_count
end
