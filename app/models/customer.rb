class Customer < ActiveRecord::Base
	has_many :checkins
	has_many :invoices
end
