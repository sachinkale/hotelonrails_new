class CreateHotelClosedCashes < ActiveRecord::Migration
  def change
    create_table :hotel_closed_cashes do |t|
      t.string :status

      t.timestamps
    end
  end
end
