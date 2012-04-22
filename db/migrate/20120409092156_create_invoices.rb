class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :customer_id
      t.string :status
      t.text :notes

      t.timestamps
    end
  end
end
