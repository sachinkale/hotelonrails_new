class Checkin < ActiveRecord::Base
	#attr_reader :discount
	#attr_reader :total_per_day

	#callbacks
 	after_initialize :init		
	after_save :block_room

	#associations
	belongs_to :customer
	belongs_to :room
	belongs_to :invoice

	#set default values
	def init
		self.extra_person = 0
		self.from_date = Date.today
		self.to_date = Date.today + 1.day
	end

	#block room as occupied
	def block_room
		self.room.set_occupied
	end

	def discount
		return 0 if self.room.nil? or (not self.room.nil? and self.room.room_type.base_rate < self.rate)
		((self.room.room_type.base_rate - self.rate)/self.room.room_type.base_rate) * 100
	end

	def total_per_day
		self.rate + self.rate * 0.10 + (self.extra_person||0)
	end

end
