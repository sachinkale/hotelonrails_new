class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :number
      t.text :facilities
      t.integer :base_rate
      t.string :status

      t.timestamps
    end
  end
end
