class Lodge::HomeController < ApplicationController
  def list
		@room_types = RoomType.all
		@rooms = Room.all
		@checkin = Checkin.new
		@payment = Payment.new
		@invoice = Invoice.new
  end

	def close_cash
    t = Invoice.arel_table
		p = Payment.arel_table
  
    @closed_cash = HotelClosedCash.last
   	if @closed_cash.nil?
      @closed_cash = HotelClosedCash.create
    else
			if @closed_cash.status == "Closed"
				created_at = @closed_cash.updated_at
				@closed_cash = HotelClosedCash.create
				@closed_cash.update(:created_at, created_at)
			end
    end


 	  @total_sale  = 0
    @total_free =  Payment.joins(:payment_method).where("payment_methods.name like 'Free'").where(p[:created_at].gt(@closed_cash.created_at))
    @total_debt =  Payment.joins(:payment_method).where("payment_methods.name like 'Debt'").where(p[:created_at].gt(@closed_cash.created_at))
    @total_card =  Payment.joins(:payment_method).where("payment_methods.name like 'Credit Card'").where(p[:created_at].gt(@closed_cash.created_at))

    @total_cash = Payment.joins(:payment_method).where("payment_methods.name like 'Cash'").where(p[:created_at].gt(@closed_cash.created_at))
		
		@cash = Payment.joins(:payment_method).where("payment_methods.name like 'cash'").where(p[:created_at].gt(@closed_cash.created_at)).select('sum(amount),owner_id')[0].send('sum(amount)')
		@card = Payment.joins(:payment_method).where("payment_methods.name like 'card'").where(p[:created_at].gt(@closed_cash.created_at)).select('sum(amount),owner_id')[0].send('sum(amount)')
		@free = Payment.joins(:payment_method).where("payment_methods.name like 'free'").where(p[:created_at].gt(@closed_cash.created_at)).select('sum(amount),owner_id')[0].send('sum(amount)')
		@debt = Payment.joins(:payment_method).where("payment_methods.name like 'debt'").where(p[:created_at].gt(@closed_cash.created_at)).select('sum(amount),owner_id')[0].send('sum(amount)')
	end

	def create_close_cash
     @closed_cash = HotelClosedCash.find(params[:id])
     @closed_cash.update_attribute(:status, "Closed")

     SendReport.daily_report(@closed_cash).deliver

  	 if not HotelClosedCash.create
       flash[:notice] = "Error while closing cash"
		 else
			 flash[:notice] = "Closed Cash Successfuly"
		 end
		 redirect_to lodge_home_list_url
	end


	def pending_invoices
			@invoices = Invoice.where("status like 'payment pending'")		


	end
end
