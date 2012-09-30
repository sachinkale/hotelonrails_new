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
	has_many :service_items
	#has_many :payments, :as => :owner

	#set default values
	def init
		self.extra_person = 0 if self.extra_person.nil?
		self.from_date = Date.today if self.from_date.nil?
		self.to_date = Date.today + 1.day if self.to_date.nil?
	end

	#block room as occupied
	def block_room
		self.room.set_occupied
	end

	#caculate discount
	def discount
		return 0 if self.room.nil? or (not self.room.nil? and self.room.room_type.base_rate < self.rate)
		(((self.room.room_type.base_rate - self.rate)/self.room.room_type.base_rate.to_f) * 100).round(2)
	end

	#total_per_day 
	def total_per_day
		r = self.rate + self.extra_person
		r + (r * self.tax(r)) 
	end


	#tax
	def tax(rate)
		if rate < 1200 and rate > 750
			l_tax = APP_CONFIG['hotel_luxury_tax1'].to_f/100
		elsif rate >= 1200
			l_tax = APP_CONFIG['hotel_luxury_tax2'].to_f/100
		else 
			l_tax = 0
		end

		if rate > 1000
			service_tax = APP_CONFIG['hotel_service_tax'].to_f/100
		else
			service_tax = 0
		end
		l_tax + service_tax
	end

	#no_of_days
	def no_of_days
		n = 0
 		if self.status.nil?
			n = n + (Date.today - from_date.to_date).to_i
			todate = Time.now
		else
			n = n + (self.checkout_date.to_date - from_date.to_date).to_i
			todate = self.checkout_date.in_time_zone
		end


 	  n = n + 1 if self.from_date.to_time.in_time_zone.hour < APP_CONFIG['hotel_checkout_hour'] 

    n = n + 1 if todate.in_time_zone.hour > APP_CONFIG['hotel_checkout_hour'] 
		
		n = 1 if n == 0

		return n 
	end

	#list_items_by_service
	def list_items(service)
		self.service_items.where("service_id = #{service.id}")
	end

	#total_items_by_service
	def list_item_total(service)
		self.service_items.where("service_id = #{service.id}").sum(:amount)
	end

	#room_charges_total
	def total
		(total_per_day * no_of_days).round
	end

	#other_charges_total
	def total_other_charges
		(self.service_items.sum(:amount)).round
	end

	def grand_total
		(self.total + self.total_other_charges).round
	end

	def checkout
		self.update_attribute(:status,"Checked Out")
		self.update_attribute(:checkout_date, Time.now)
		self.room.update_attribute("status",nil)
	end
end
