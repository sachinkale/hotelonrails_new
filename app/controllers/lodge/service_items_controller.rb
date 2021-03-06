class Lodge::ServiceItemsController < ApplicationController

  def get_service_item
    @service_item = ServiceItem.find(params[:id])
    respond_to do |format|
      format.js
    end


  end

  def add_item
    if params[:service_item][:amount] == ""
      @error = "Please add amount!"
    else
      @service_item = ServiceItem.new(params[:service_item])

			@service_item.date = Time.local(Time.new.year(),params[:date][:month],params[:date][:day],params[:date][:hour],params[:date][:minute])
      @service_item.save!
    end
    respond_to do |format|
      format.html { redirect_to "/checkins"}
      format.js
    end
  end

  
  def delete_item
    @service_item = ServiceItem.find(params[:delete_service_item_id])
    @checkin = @service_item.checkin
		@service = @service_item.service
    @service_item.destroy
    respond_to do |format|
      format.js
    end
  end
end
