HotelonrailsNew::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
	namespace 'lodge' do
  	get "home/list"
		resources :checkins
	end
  root :to => "home#index"
end
