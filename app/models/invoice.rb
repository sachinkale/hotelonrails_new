class Invoice < ActiveRecord::Base
	has_many :checkins
	belongs_to :customer

	has_many :payments, :as => :owner
end
