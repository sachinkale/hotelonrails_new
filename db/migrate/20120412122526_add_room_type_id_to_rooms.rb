class AddRoomTypeIdToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :room_type_id, :integer

  end
end
