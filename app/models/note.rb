class Note < ActiveRecord::Base
  attr_accessible :action_date, :body, :related_profile_id, :reminder, :task, :title, :task_status
end
