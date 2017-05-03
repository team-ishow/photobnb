class AddMakeupToListing < ActiveRecord::Migration
  def change
    add_column :listings, :make_up, :boolean
  end
end
