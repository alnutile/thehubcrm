class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title
      t.boolean :task
      t.date :action_date
      t.boolean :reminder
      t.text :body
      t.string :related_profile_id

      t.timestamps
    end
  end
end
