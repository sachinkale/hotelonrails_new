class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :payment_method_id
      t.float :amount
      t.integer :owner_id
      t.string :owner_type

      t.timestamps
    end
  end
end
