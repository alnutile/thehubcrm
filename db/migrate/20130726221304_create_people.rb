class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :image
      t.string :network_id

      t.timestamps
    end
  end
end
