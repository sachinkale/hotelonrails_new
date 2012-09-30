class Invoice < ActiveRecord::Base
	has_many :checkins
	belongs_to :customer

	has_many :payments, :as => :owner
	
	scope :valid, where("status is not null")

	def grand_total
		t = 0
		checkins.each do |c1|
			t = t + c1.grand_total
		end
		return t.round
	end

	def room_total
		t = 0
		checkins.each do |c|
			t = t + c.total
		end
		return t.round

	end

	def total_other_charges
		t = 0
		checkins.each do |c|
			t = t + c.total_other_charges
		end
		return t.round

	end
	
	def checked_out_checkins
		checkins.where("status like 'Checked Out'")
	end
end
