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
    @checkin.status = "Checked Out"
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /checkins
  # POST /checkins.xml
  def create
   respond_to do |format|
					 
		format.html do
			redirect_to lodge_home_list_url, :notice => 'done'
		end
	 end
  end

  # PUT /checkins/1
  # PUT /checkins/1.xml
  def update
    @checkin = Checkin.find(params[:id])
    params[:checkin][:description] =  params[:select_description] + " : " + params[:checkin][:description] 
    respond_to do |format|
      if @checkin.update_attributes(params[:checkin])
        @checkin.checkout if not @checkin.status.nil?
        format.html { redirect_to(user_root_url, :notice => 'Checkin was successfully updated.') }
        format.js { }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @checkin.errors, :status => :unprocessable_entity }
      end
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
    @title = "Print Invoice"
    respond_to do |format|
      format.html { render :layout => "print"}
    end
  end
 
  def split_room
    line_item = LineItem.find(params[:splitroom_line_item_id].sub(/\D+/,'').to_i)
    flag = 0
    if line_item.freez
      flag = 1
    else
      checkin = Checkin.new
      checkin.company = line_item.checkin.company if not line_item.checkin.company.nil?
      checkin.save!
      checkin.guests << line_item.checkin.guests
      line_item.checkin.service_items.each do |si|
        if si.room_id == line_item.room_id
          si.checkin = checkin
          si.save!
        end
      end
      line_item.checkin = checkin
      line_item.save!
      checkin.update_fromdate
    end
    respond_to do |format|
      format.html {
        if flag == 1
          flash[:notice] = "Cannot Split Room as the room is shifted"
        else
          flash[:notice] = "Splitted Room as a new checkin successfully"
        end
        redirect_to user_root_url
      }
    end
  end

  def shift_room

    myarr = params[:shiftroom_room_id_checkin_id].split(/-/)
    from_room = Room.find(myarr[1])
    checkin = Checkin.find(myarr[3])
    to_room = Room.find(params[:shift_room_id])
    line_item = LineItem.where("checkin_id = ? and room_id = ?",checkin.id,from_room.id).first

    if params[:rate] == ""
      rate = to_room.room_type.baserate
    else
      rate = params[:rate].to_i
    end
    
    if params[:tax] == ""
      tax = 0
    else 
      tax = params[:tax]
    end
    
    shift_time = Time.local(params[:shift_room]["shift_time(1i)"],params[:shift_room]["shift_time(2i)"],params[:shift_room]["shift_time(3i)"],params[:shift_room]["shift_time(4i)"],params[:shift_room]["shift_time(5i)"])


    if line_item.no_of_days > 1 
      line_item.update_attributes(:todate => shift_time, :freez => true)
      new_line_item = LineItem.create({:room_id => to_room.id, :fromdate => shift_time, :checkin_id => checkin.id, :extraperson => line_item.extraperson, :tax => line_item.tax, :rate => rate})
    else
      line_item.update_attribute(:room_id,to_room.id)
      line_item.update_attribute(:rate,rate)
      line_item.update_attribute(:tax,tax.to_f)
    end

    from_room.update_attribute('status',nil)
    to_room.update_attribute('status','blocked - checked in')

    respond_to do |format|
      format.html {
        flash[:notice] = "Shifted Room successfully!"
        redirect_to user_root_url
      }
    end


  end

  
end
