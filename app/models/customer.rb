class Customer < ActiveRecord::Base
	has_many :checkins
end
