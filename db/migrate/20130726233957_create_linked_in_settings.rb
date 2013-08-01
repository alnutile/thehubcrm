class CreateLinkedInSettings < ActiveRecord::Migration
  def change
    create_table :linked_in_settings do |t|
      t.string :key
      t.string :secret
      t.datetime :synced_last
      t.integer :total_count

      t.timestamps
    end
  end
end
