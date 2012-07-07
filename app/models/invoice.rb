class Invoice < ActiveRecord::Base
	has_many :checkins
	belongs_to :customer
end
