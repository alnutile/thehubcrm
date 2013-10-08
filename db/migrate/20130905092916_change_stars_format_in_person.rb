class ChangeStarsFormatInPerson < ActiveRecord::Migration
  def up
	change_column :people, :stars, :string
  end

  def down
  end
end
