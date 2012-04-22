class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.text :address
      t.string :phone
      t.string :email
      t.date :birthday
      t.date :anniversary

      t.timestamps
    end
  end
end
