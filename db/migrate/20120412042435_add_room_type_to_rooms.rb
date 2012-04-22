class AddRoomTypeToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :room_type, :string

  end
end
