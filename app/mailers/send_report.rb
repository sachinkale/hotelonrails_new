class SendReport < ActionMailer::Base
  default :from => "sachin@hotelsahara.in"

  def daily_report(cc)
    @closed_cash = cc
    mail(:to => "brightspark@gmail.com,vikaskale2@gmail.com,manager@hotelsahara.in", :subject => "[Hotel-Sahara] Daily Report")
  end

	def checkin_change(checkin,new_checkin)
		@old_checkin = checkin
		@new_checkin = new_checkin
    mail(:to => "brightspark@gmail.com,vikaskale2@gmail.com,manager@hotelsahara.in", :subject => "[Hotel-Sahara] Checkin Change")
	end
end
