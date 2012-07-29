ActiveAdmin.register Invoice do

	actions :all, :except => [:new]
  
	member_action :print, :method => :get do
		@invoice = Invoice.find(params[:id])
	end

  index do 
    column "Bill Number", :id
    column "Rooms" do |invoice|
			rooms = ""
      invoice.checkins.each do |c|
				rooms = rooms + c.room.number + ','
			end
			rooms
    end
		column "Customer" do |invoice|
			invoice.customer.name if not customer.nil?
		end
		column "Amount" do |invoice|
			invoice.grand_total
		end
		column "Status",:status
		column "Actions" do |invoice|
			link_to "Print",print_admin_invoice_path(invoice)
		end
	end

	member_action :print, :method => :get do
		@invoice = Invoice.find(params[:id])
		@invoice.checkins.each do |c|
				@checkin = c
		end
	end

  csv do
    column :id
    column("Rooms") do |invoice|
  		rooms = ""
      invoice.checkins.each do |c|
				rooms = rooms + c.room.number + ','
			end
			rooms   
    end
    column :created_at
    column :grand_total
    column :status
  end





end
