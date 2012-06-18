class Lodge::HomeController < ApplicationController
  def list
		@room_types = RoomType.all
		@rooms = Room.all
		@checkin = Checkin.new
		@payment = Payment.new
  end
end
