HotelonrailsNew::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
	namespace 'lodge' do
  	get "home/list"
		put "checkins/checkout/:id",:controller => "checkins", :action => "checkout", :as => "checkout"
		put "checkins/shift_room",:controller => "checkins", :action => "shift_room", :as => "shift_room"
		resources :checkins
		resources :invoices
		post "service_items/add_item", :as => "add_service_item"
    delete "service_items/delete_item", :as => "delete_service_item"
	end

	resources :payments
  root :to => "home#index"
end
