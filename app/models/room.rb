class Room < ActiveRecord::Base
	belongs_to :room_type

	def set_occupied
		self.update_attribute("status","occupied")
	end

	def current_checkin
		Checkin.where("status is null").where("room_id = ?", self.id).first
	end
end
