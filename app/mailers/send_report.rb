class SendReport < ActionMailer::Base
  default :from => "sachin@hotelsahara.in"

  def daily_report(cc)
    @closed_cash = cc
    mail(:to => "brightspark@gmail.com,vikaskale2@gmail.com", :subject => "Hotel Sahara Daily Report")
  end
end
