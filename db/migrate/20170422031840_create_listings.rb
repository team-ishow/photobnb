class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :photo_type
      t.string :camera_type
      t.string :photo_time
      t.string :finish_time
      t.string :address
      t.string :listing_title
      t.text :listing_content
      t.integer :price_photo
      t.boolean :active
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
