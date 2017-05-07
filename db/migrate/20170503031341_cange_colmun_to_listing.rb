class CangeColmunToListing < ActiveRecord::Migration
  def change
    change_column :listings, :make_up, :boolean, null: false, default: false
    change_column :listings, :clothes, :boolean, null: false, default: false
    change_column :listings, :photo_album, :boolean, null:false, default:false
    change_column :listings, :transport_expenses, :boolean, null:false, default:false
  end
end
