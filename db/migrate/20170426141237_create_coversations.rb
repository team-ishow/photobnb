class CreateCoversations < ActiveRecord::Migration
  def change
    create_table :coversations do |t|
      t.integer :sender_id
      t.integer :recipient_id

      t.timestamps null: false
    end
  end
end
