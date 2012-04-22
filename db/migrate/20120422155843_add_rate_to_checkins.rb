class AddRateToCheckins < ActiveRecord::Migration
  def change
    add_column :checkins, :rate, :integer
		add_column :checkins, :extra_person, :float
  end
end
