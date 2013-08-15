class AddColumnsAtokenAsecretRtokenRsecretPinToLinkedInSetting < ActiveRecord::Migration
  def change
    add_column :linked_in_settings, :atoken, :string
    add_column :linked_in_settings, :asecret, :string
    add_column :linked_in_settings, :rtoken, :string
    add_column :linked_in_settings, :rsecret, :string
    add_column :linked_in_settings, :pin, :string
  end
end
