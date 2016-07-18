Rails.application.routes.draw do
  resources :addresses, only: [:index, :create, :update, :destroy]
  match 'addresses', to: 'addresses#options', via: [:options]
  match 'addresses/:id', to: 'addresses#options', via: [:options]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
