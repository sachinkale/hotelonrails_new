class CreateServiceItems < ActiveRecord::Migration
  def change
    create_table :service_items do |t|
      t.integer :service_id
      t.integer :amount
      t.integer :bill_number
      t.integer :checkin_id
      t.integer :room_id
      t.datetime :date
      t.text :notes

      t.timestamps
    end
  end
end
