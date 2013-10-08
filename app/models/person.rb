class Person < ActiveRecord::Base
  attr_accessible :first_name, :image, :last_name, :network_id, :stars
  has_many :notes, :foreign_key => "related_profile_id", :primary_key => "network_id"
end
