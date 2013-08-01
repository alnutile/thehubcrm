class Note < ActiveRecord::Base
  attr_accessible :action_date, :body, :related_profile_id, :reminder, :task, :title, :task_status

  #Note.where(:reminder => true)
  #scope :published, -> { where published: true }
  #scope :has_date, -> { where("date IS NOT NULL")} 
  #scope :content, ->(searched) { where(["content LIKE ?", "%#{searched}%"]) }
  scope :reminders_all, -> { where reminder: true }
  #scope :reminders_open, -> { where reminder: true, task_status: false }.count()
  scope :tasks_all, -> { where task: true }
  
end
