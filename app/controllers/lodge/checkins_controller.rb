class Lodge::CheckinsController < ApplicationController
  #before_filter :authenticate_user!

  # GET /checkins
  # GET /checkins.xml
  def index
    #@checkins = Checkin.where("status is NULL")

    @checkins = Checkin.paginate :page => params[:page],:order => "updated_at desc"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @checkins }
    end
  end

  # GET /checkins/1
  # GET /checkins/1.xml
  def show
    @checkin = Checkin.find(params[:id])

    respond_to do |format|
      format.js
      format.html # show.html.erb
      format.xml  { render :xml => @checkin }
    end
  end

  # GET /checkins/new
  # GET /checkins/new.xml
  def new
    @checkin = Checkin.new
    @rooms = Room.where("status is NULL");
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @checkin }
    end
  end

  # GET /checkins/1/edit
  def edit
    @checkin = Checkin.find(params[:id])
    #@checkin.status = "Checked Out"
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /checkins
  # POST /checkins.xml
  def create
   respond_to do |format|
					 
		#format.html do
		#		redirect_to lodge_home_list_url, :notice => 'done'
		#	end
		
		format.html do
			@room = Room.find(params[:checkin][:room_id])
			@error = "Checked in Successful"
			if @room.status.nil?
				#deleting values not meant to be saved
				params[:checkin].delete(:discount)
				params[:checkin].delete(:total_per_day)

				#save customer
				@customer = Customer.create(params[:checkin][:customer])
				params[:checkin].delete(:customer)

				@checkin = Checkin.new(params[:checkin])
				@checkin.from_date = Time.new(@checkin.from_date.year,@checkin.from_date.month,@checkin.from_date.day,params[:date][:hour],params[:date][:minute],0,Time.now.utc_offset)
				#@checkin.from_date = Time.now
				@checkin.customer = @customer
				@invoice = Invoice.new
				@invoice.customer = @customer
				@invoice.save
				@checkin.invoice = @invoice
				@checkin.save
			else
				@error = "room already occupied"
			end
			redirect_to lodge_home_list_url, :notice => @error		
		end

	 end
  end

  # PUT /checkins/1
  # PUT /checkins/1.xml
  def update
    @checkin = Checkin.find(params[:id])
		@customer = Customer.find(params[:checkin][:customer][:id])
    #params[:checkin][:description] =  params[:select_description] + " : " + params[:checkin][:description] 
    respond_to do |format|
			params[:checkin][:customer].delete(:id)
			@customer.update_attributes(params[:checkin][:customer])
			params[:checkin].delete(:customer)
			params[:checkin].delete(:discount)
			params[:checkin].delete(:total_per_day)

			date = Date.parse(params[:checkin][:from_date])
			params[:checkin][:from_date] = Time.local(date.year,date.month,date.day,params[:date][:hour],params[:date][:minute])
			params[:checkin].delete(:date)
			if params[:checkin][:rate] < @checkin.rate or params[:checkin][:from_date] > @checkin.from_date
				SendReport.checkin_change(@checkin,params[:checkin]).deliver
			end
      @checkin.update_attributes(params[:checkin])
			format.js
    end
  end

  # DELETE /checkins/1
  # DELETE /checkins/1.xml
  def destroy
    @checkin = Checkin.find(params[:id])
    @checkin.destroy

    respond_to do |format|
      format.html { redirect_to(checkins_url) }
      format.xml  { head :ok }
    end
  end

  def checkout
    @checkin = Checkin.find(params[:id])
		@checkin.checkout
		@checkin.invoice.payments.each do |p|
			if p.payment_method.name == "Debt"
				@checkin.invoice.update_attribute(:status, "payment pending")
			end
		end
		@checkin.invoice.update_attribute(:status, "closed") if @checkin.invoice.status.nil?
    respond_to do |format|
      format.js {}
    end
  end
 

  def shift_room

    checkin = Checkin.find(params[:shift_room_checkin_id])
    to_room = Room.find_by_number(params[:room_list])

    if checkin.no_of_days > 1 
			new_checkin = Checkin.new
			new_checkin.customer = checkin.customer
			new_checkin.invoice = checkin.invoice
			new_checkin.from_date = Time.now
			new_checkin.room = to_room
			new_checkin.rate = to_room.room_type.base_rate
			new_checkin.save
			checkin.checkout
		else
			checkin.room.update_attribute(:status,nil)
			checkin.rate = to_room.room_type.base_rate
			checkin.room = to_room
			checkin.save
		end

    to_room.update_attribute('status','occupied')

    respond_to do |format|
      format.html {
        flash[:notice] = "Shifted Room successfully!"
        redirect_to lodge_home_list_url
      }
    end


  end

  
end
