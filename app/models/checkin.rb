class Checkin < ActiveRecord::Base
	attr_reader :discount
	attr_reader :total_per_day

	belongs_to :customer
	belongs_to :room
	belongs_to :invoice

	def discount
		return 0 if self.room.nil? or (not self.room.nil? and self.room.room_type.base_rate < self.rate)
		((self.room.room_type.base_rate - self.rate)/self.room.room_type.base_rate) * 100
	end

	def total_per_day
		self.rate + self.rate * 0.10 + (self.extra_person||0)
	end

end
