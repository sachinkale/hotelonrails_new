class ServiceItem < ActiveRecord::Base
	belongs_to :checkin
	belongs_to :service
end
