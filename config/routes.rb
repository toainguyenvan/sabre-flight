Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'home#index'
  match 'sign_in', to: 'home#new', via: :get
  match 'sign_out', to: 'home#sign_out', via: :get
  match 'flight_search', to: 'flight_search#index', via: [:get, :post]
  match 'sign_in', to: 'home#sign_in', via: :post
  namespace :home do
   get 'index'
   post 'get_token'
end
end
