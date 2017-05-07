class RemoveLatitudeFromListing < ActiveRecord::Migration
  def change
    remove_column :listings, :latitude, :float
    remove_column :listings, :longitude, :float
  end
end
