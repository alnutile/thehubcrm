class AddStatusToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :task_status, :boolean, :default => false
  end
end
