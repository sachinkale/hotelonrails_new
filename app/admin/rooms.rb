ActiveAdmin.register Room do
	

	index do 
		column "number" do |room|
			room.number
		end
		column "status" do |room|
			room.status
		end

	end
end
