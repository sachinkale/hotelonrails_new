class RoomType < ActiveRecord::Base
	has_many :rooms

	def vacant_rooms
		self.rooms.where("status is Null");
	end

	def name_base_rate
		"#{name} - Base Rate:#{base_rate}"
	end
end
