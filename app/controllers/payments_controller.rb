class PaymentsController < ApplicationController
  def create 
    #params[:payment][:amount] = params[:amount_total]   if params[:payment][:payment_method_id] == "2"

    if params[:payment][:amount] == "" or params[:payment][:amount] == "0"
      @error = "Amount cannot be blank or zero"
    else

		 @payment = Payment.create(params[:payment])
		 @invoice = Invoice.find(params[:payment][:owner_id])
     # @ticket = Ticket.find(params[:payment][:owner_id])
     #if (params[:payment][:payment_method_id] == "3" or params[:payment][:payment_method_id] == "4") and @ticket.guest.nil?
     #   @error = "Customer should be added for debt/free payments"
     # else
     #   @payment = Payment.create(params[:payment])
     #   @total_payments = @ticket.payments.sum(:amount)
     # end
    end
    respond_to do |format|
      format.js
    end
  end

  def create_debt_payment
    @guest = Guest.find(params[:guest_id])
    @debtpayment = DebtPayment.create(:guest_id => @guest.id)
    params[:payment][:owner_type] = "DebtPayment"
    params[:payment][:owner_id] = @debtpayment.id
    respond_to do |f|
      f.html do 
        if Payment.create(params[:payment])
          flash[:notice] = "Payment Created"
          redirect_to debt_payment_path
        else
          flash[:notice] = "Error occured"
          redirect_to guest_debt_path(:id => @guest.id)
        end
      end
    end
      




  end

  def destroy
    @payment = Payment.find(params[:id])
    #@ticket = Ticket.find(@payment.owner_id)
    @invoice = Invoice.find(@payment.owner_id)
    @error = true
    if @payment.destroy
      @error = false
      #@total_payments = @ticket.payments.sum(:amount)
    end
    respond_to do |format|
      format.js
    end
  end

end

