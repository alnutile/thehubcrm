class AddStarsToPerson < ActiveRecord::Migration
  def change
    add_column :people, :stars, :integer
  end
end
