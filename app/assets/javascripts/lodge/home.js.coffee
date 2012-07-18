# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
#
jQuery ->
	#available room select change
	#
	$('.form-horizontal').removeAttr('novalidate')
	$('#room_type').change ->
		$('.room_type').hide()
		$('#rt' + $(@).find('option:selected').val()).show()

	#populate form under room tab pane
	$('a[data-toggle="tab"]').on 'shown',(e) ->
		href = $(e.target).attr('href')
		calculate_room_total()

	$('#checkinsubmit').click ->
		$('#new_checkin').submit()

	#attach events
	$('.discount').on 'change', ->
		update_rate_and_calculate_room_total()
	$('.rate').on 'change', ->
		calculate_room_total()
	$('.extra_person').on 'change', ->	
		update_rate_and_calculate_room_total()

	update_rate_and_calculate_room_total = ->
		base_rate = parseInt $('.tab-pane.active').find('.base_rate').val()
		extra_person = parseInt $('.tab-pane.active').find('.extra_person').val()
		discount =  parseFloat $('.tab-pane.active').find('.discount').val()

		#validate values for NaN
		base_rate = 0 if !base_rate 
		extra_person = 0 if !extra_person 
		discount = 0 if !discount

		#calculate actual rate
		rate = (base_rate + extra_person) - ((base_rate + extra_person) * discount/100) 
		$('.tab-pane.active').find('.rate').val rate

		#calculate total with tax
		calculate_room_total()

	calculate_room_total = ->
		#read values

		actual_rate = parseInt $('.tab-pane.active').find('.rate').val() 
		tax = parseFloat $('.tax').text()

		actual_rate = 0 if !actual_rate 
		tax = 0 if !tax 

		
		#calculate total
		total = actual_rate + (actual_rate * tax/100)

		#update total
		$('.tab-pane.active').find('.total_per_day').val total

	#activate room tabs
  $('#room_tabs').tab('show')

	$('.add_service').click ->
		$('#service_item_service_id').val($(@).attr('href').replace('#',''))
		$('#service_item_checkin_id').val($(@).parents('.checkin').attr('id').replace('checkin-',''))
		$('#service_form').modal 'show' 
		return false

	#add service item
	$('#save_service_item').click ->
		$('#item_loader').show()
		$('#service_item_form').submit()

	#delete service item
	$('.delete_service_item').click ->
		$('#delete_service_item_id').val($(@).parents('tr').attr('id').replace('service_item_',''))
		$('#delete_service').modal 'show'
	$('#delete_service_item').click ->
		$('#delete_item_loader').show()
		$('#delete_service_item_form').submit()

	#add payment
	$('.add_payment').click ->
		$('#pay_dialog').modal 'show'
		$('#payment_owner_id').val($(@).parents('.checkin').attr('id').replace('checkin-',''))
		$('#payment_owner_type').val("Checkin")

	$('#add_payment_submit').click ->
		$('#add_payment_loader').show()
		$('#new_payment').submit()
	
	#print
	$('.print-button').on 'click', -> 
		c = $(@).attr('id').match(/\d+/)[0]
		$('#print_dialog #print_invoice_id').val($('#checkin-' + c + ' #invoice_id').val())
		$('#print_dialog .customer-name').html($('#checkin-' + c + ' .invoice-details #customer_name ').val())
		$('#print_checkin_id').val(c)
		$('#print_dialog').modal 'show'

	$('#add_invoice_submit').on 'click', ->
		$('#print_dialog').modal 'hide'
		printCurrent($('#print_checkin_id').val())

	$('#print_dialog #change_customer').click ->
		$('#print_dialog #print_form').show()

	$('#submit_invoice_customer').click ->
		if($.trim($('#print_form #name').val()) == '')
			alert 'Name is required'
			return false
		if($.trim($('#print_form #address').val()) == '')
			alert 'address is required'
			return false
		if($.trim($('#print_form #phone').val()) == '')
			alert 'mobile is required'
			return false
		data = '&name=' + $('#print_form #name').val()
		data += '&phone='+ $('#print_form #phone').val()
		data += '&address='+ $('#print_form #address').val()
		
		$.ajax
			url: "/lodge/invoices/" + $('#print_invoice_id').val()
			data: data
			type: 'PUT'
			beforeSend: ->
				$('#submit_invoice_customer').text('Changing Customer Please Wait')
				$('#submit_invoice_customer').attr('disabled',true)
			success: ->
				$('#submit_invoice_customer').text('Change Customer')
				$('#submit_invoice_customer').attr('disabled',false)
				$('#print_form').hide()
				$('#print_dialog .customer-name').html($('#print_form #name').val())
				c = $('#print_checkin_id').val();
				$('#checkin-' + c + ' .invoice-details #customer_name ').val($('#print_form #name').val())
				return false
			error: ->
				alert 'updation failed'
				$('#submit_invoice_customer').text('Change Customer')
				$('#submit_invoice_customer').attr('disabled',false)
				return false
	
			


	$('.checkout-button').click ->
		c = $(@).attr('id').match(/\d+/)[0]
		if(parseInt($.trim($('#checkin-' + c + ' .total_pending').text())) == 0)
			$.ajax
				type: 'PUT'
				url: '/lodge/checkins/checkout/' + c
				beforeSend: ->
					$(@).text('Please Wait')
					$(@).attr('disabled',true)
				success: ->
					window.location.href = '/lodge/home/list' 
				error: ->
					$(@).text('Checkout')
					$(@).attr('disabled',false)
					alert 'Error Checking out'
					return false
		else
			alert 'Please add payments'
			return false
		

	printCurrent = (c) ->
		w = window.open("")
		w.document.write("<html><head></head><body>")
		w.document.write($('#hotel-details').html())
		w.document.write("<hr/>")
		w.document.write('<div style="float:right;width:150px">')
		w.document.write('Invoice Number: ')
		w.document.write($('#checkin-' + c + ' #invoice_id').val())
		w.document.write('</div>')
		w.document.write("Guest Name: ")
		w.document.write("<b>")
		w.document.write($('#checkin-' + c + ' .invoice-details #customer_name').val())
		w.document.write("</b>")
		w.document.write("<br/>Checked in Date: ")
		w.document.write("<b>")
		w.document.write($('#checkin-' + c + ' .well.checkin-details .checkin-date').html())
		w.document.write("</b>")
		w.document.write("<h4>Room Charges</h4>")
		w.document.write("<table rules=all border=1 cellpadding=5>")
		w.document.write($('#checkin-' + c + ' .well.checkin-details table').html())
		w.document.write("</table>")
		w.document.write("<h4>Total Charges to be Paid: Rs. ")
		w.document.write($('#checkin-' + c + ' .room_charges').html())
		w.document.write("</h4>")
		w.document.write("</body></html>")
		w.print()
		if $.trim($('#checkin-' + c + ' .other_charges').text()) != "0" 
			l = window.open("")
			l.document.write("<html><head></head><body>")
			l.document.write($('#hotel-details').html())
			l.document.write("<hr/>")
			l.document.write("Guest Name: ")
			l.document.write("<b>")
			l.document.write($('#checkin-' + c + ' .well.checkin-details .customer-name').html())
			l.document.write("</b>")
			l.document.write("<br/>Checked in Date: ")
			l.document.write("<b>")
			l.document.write($('#checkin-' + c + ' .well.checkin-details .checkin-date').html())
			l.document.write("</b>")
			l.document.write("<h4>Other Charges</h4>")
			l.document.write("<h4>"+ $($('#checkin-' + c + ' .well.services .service-name')[0]).html() + "</h4>")
			l.document.write("<table rules=all border=1 cellpadding=5>")
			l.document.write($($('#checkin-' + c + ' .well.services table')[0]).html())
			l.document.write("</table>")
			l.document.write("<h4>"+ $($('#checkin-' + c + ' .well.services .service-name')[1]).html() + "</h4>")
			l.document.write("<table rules=all border=1 cellpadding=5>")
			l.document.write($($('#checkin-' + c + ' .well.services table')[1]).html())
			l.document.write("</table>")

			l.document.write("<h4>Total Charges to be Paid: Rs. ")
			l.document.write($('#checkin-' + c + ' .other_charges').html())
			l.document.write("</h4>")
			l.document.write("</body></html>")
			l.print()
	$('.checkout-button').click ->
		c = $(@).attr('id').match(/\d+/)[0]
		$('#checkin-' + c + ' .total_pending')
