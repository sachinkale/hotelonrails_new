class AddCheckoutDateToCheckins < ActiveRecord::Migration
  def change
    add_column :checkins, :checkout_date, :datetime

  end
end
