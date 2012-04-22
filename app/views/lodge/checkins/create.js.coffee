<% if @checkin.errors.any? %>
  d = $('<div class="alert alert-error"></div>').append($('<a class="close" data-dismiss="alert"></a>').text(<%= @checkin.errors.full_messages.join("<br/>") %>))
	$('.content .row-fluid').append(d)
<% else %>
	$('.tab-pane.active .span6').find($('.form-horizontal')).remove()
	$('.tab-pane.active .span6').append( $('<div class="alert alert-success"></div>').append($('<a class="close" data-dismiss="alert">×</a>')).text('Checked in succesfully!'))
<% end %>
