class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.datetime :from_date
      t.datetime :to_date
      t.string :status
      t.integer :room_id
      t.text :notes

      t.timestamps
    end
  end
end
