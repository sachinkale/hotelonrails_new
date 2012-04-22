class CreateRoomTypes < ActiveRecord::Migration
  def change
    create_table :room_types do |t|
      t.string :name
      t.integer :base_rate
      t.text :facilities

      t.timestamps
    end
  end
end
