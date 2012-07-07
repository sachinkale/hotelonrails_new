class Lodge::InvoicesController < ApplicationController

	def update
		@invoice = Invoice.find(params[:id])
		respond_to do |format|
			format.js do
				if not @invoice.nil?
					c = Customer.create(:name => params[:name], :address => params[:address], :phone => params[:phone])
					@invoice.customer = c
					if not @invoice.save
						render :status => 500
					end

				else
					render :status => 500
				end
			end
		end


	end




end

