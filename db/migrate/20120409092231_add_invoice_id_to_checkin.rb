class AddInvoiceIdToCheckin < ActiveRecord::Migration
  def change
    add_column :checkins, :invoice_id, :integer
    add_column :checkins, :customer_id, :integer

  end
end
