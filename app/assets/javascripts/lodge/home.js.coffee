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

