class HotelClosedCash < ActiveRecord::Base
  def invoices
    t = Invoice.arel_table
    Invoice.valid.where(t[:created_at].gt(created_at)).where(t[:updated_at].lt(updated_at)).map{ |t| t.id }
  end

  def cash
		p = Payment.arel_table
		Payment.joins(:payment_method).where("payment_methods.name like 'cash'").where(p[:created_at].gt(self.created_at)).select('sum(amount),owner_id')[0].send('sum(amount)')
  end

  def card

 		p = Payment.arel_table
		Payment.joins(:payment_method).where("payment_methods.name like 'Credit Card'").where(p[:created_at].gt(self.created_at)).select('sum(amount),owner_id')[0].send('sum(amount)')
  end

  def debt
 		p = Payment.arel_table
		Payment.joins(:payment_method).where("payment_methods.name like 'Debt'").where(p[:created_at].gt(self.created_at)).select('sum(amount),owner_id')[0].send('sum(amount)')
   end

  def free
 		p = Payment.arel_table
		Payment.joins(:payment_method).where("payment_methods.name like 'Free'").where(p[:created_at].gt(self.created_at)).select('sum(amount),owner_id')[0].send('sum(amount)')
  end

  def total
    (cash || 0)   +  (card || 0 )  + ( debt || 0 ) + (free || 0)
  end


end
