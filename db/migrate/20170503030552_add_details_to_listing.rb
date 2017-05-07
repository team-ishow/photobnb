class AddDetailsToListing < ActiveRecord::Migration
  def change
    add_column :listings, :clothes, :boolean
    add_column :listings, :photo_album, :boolean
    add_column :listings, :transport_expenses, :boolean
  end
end
