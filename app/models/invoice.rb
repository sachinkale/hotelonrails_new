class Invoice < ActiveRecord::Base
	has_many :checkins
end
