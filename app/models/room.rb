class Room < ActiveRecord::Base
	belongs_to :room_type

	def set_occupied
		self.update_attribute("status","occupied")
	end
end
