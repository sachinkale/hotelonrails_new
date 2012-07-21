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
      invoices = Invoice.valid.map{ |ti| ti.id }
      @closed_cash = HotelClosedCash.create
    else
			if @closed_cash.status == "Closed"
				created_at = @closed_cash.updated_at
				@closed_cash = HotelClosedCash.create
				@closed_cash.update(:created_at, created_at)
			end
      invoices = Invoice.valid.where(t[:created_at].gt(@closed_cash.created_at)).map{ |ti| ti.id }
    end
		@cash = PaymentMethod.where("name like 'Cash'")[0]
		@debt = PaymentMethod.where("name like 'Debt'")[0]
		@free = PaymentMethod.where("name like 'Free'")[0]
		@card = PaymentMethod.where("name like 'Credit Card'")[0]

		@cash_invoices = Invoice.joins(:payments).where(t[:created_at].gt(@closed_cash.created_at)).where(p[:payment_method_id].eq(@cash.id)).where("status is not null") 

 		@debt_invoices = Invoice.joins(:payments).where(t[:created_at].gt(@closed_cash.created_at)).where(p[:payment_method_id].eq(@debt.id)).where("status is not null") 

 		@free_invoices = Invoice.joins(:payments).where(t[:created_at].gt(@closed_cash.created_at)).where(p[:payment_method_id].eq(@free.id)).where("status is not null")

 		@card_invoices = Invoice.joins(:payments).where(t[:created_at].gt(@closed_cash.created_at)).where(p[:payment_method_id].eq(@card.id)).where("status is not null")

 	  @total_sale  = 0
    @total_free =  Payment.joins(:payment_method).where("payment_methods.name like 'Free'").where("payments.owner_id in (?)", invoices).select('sum(amount)')[0].send('sum(amount)')
    @total_debt =  Payment.joins(:payment_method).where("payment_methods.name like 'Debt'").where("payments.owner_id in (?)", invoices).select('sum(amount)')[0].send('sum(amount)')
    @total_card =  Payment.joins(:payment_method).where("payment_methods.name like 'Credit Card'").where("payments.owner_id in (?)", invoices).select('sum(amount)')[0].send('sum(amount)')

    @total_cash = Payment.joins(:payment_method).where("payment_methods.name like 'Cash'").where("payments.owner_id in (?)", invoices).select('sum(amount)')[0].send('sum(amount)')

	end

	def create_close_cash
     @closed_cash = HotelClosedCash.find(params[:id])
     @closed_cash.update_attribute(:status, "Closed")
  	 if not HotelClosedCash.create
       flash[:notice] = "Error while closing cash"
		 else
			 flash[:notice] = "Closed Cash Successfuly"
		 end
		 redirect_to lodge_home_list_url
	end
end
