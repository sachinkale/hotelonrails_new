HotelonrailsNew::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
	namespace 'lodge' do
  	get "home/list"
		resources :checkins
		post "service_items/add_item", :as => "add_service_item"
    delete "service_items/delete_item", :as => "delete_service_item"
	end
  root :to => "home#index"
end
