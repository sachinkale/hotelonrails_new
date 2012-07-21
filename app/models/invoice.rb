class Invoice < ActiveRecord::Base
	has_many :checkins
	belongs_to :customer

	has_many :payments, :as => :owner
	
	scope :valid, where("status is not null")

	def grand_total
		t = 0
		self.checkins.each do |c|
			t = t + c.grand_total
		end
		return t
	end

	def room_total
		t = 0
		self.checkins.each do |c|
			t = t + c.total
		end
		return t

	end

	def total_other_charges
		t = 0
		self.checkins.each do |c|
			t = t + c.total_other_charges
		end
		return t

	end
	
	def checked_out_checkins
		self.checkins.where("status like 'Checked Out'")
	end
end
