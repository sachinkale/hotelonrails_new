class Payment < ActiveRecord::Base
	belongs_to :owner
	belongs_to :payment_method
	
end
