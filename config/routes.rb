Rails.application.routes.draw do
  get '/', to: 'application#welcome'

  get '/admin/shelters', to: 'shelters#index'
  get '/admin/shelters/new', to: 'shelters#new'
  get '/admin/shelters/:id', to: 'shelters#show'
  post '/admin/shelters', to: 'shelters#create'
  get '/admin/shelters/:id/edit', to: 'shelters#edit'
  patch '/admin/shelters/:id', to: 'shelters#update'
  delete '/admin/shelters/:id', to: 'shelters#destroy'

  get '/admin/shelters/:shelter_id/pets', to: 'shelters#pets'
  get '/admin/shelters/:shelter_id/pets/new', to: 'pets#new'
  post '/admin/shelters/:shelter_id/pets', to: 'pets#create'

  get '/pets', to: 'pets#index'
  get '/pets/:id', to: 'pets#show'
  get '/pets/:id/edit', to: 'pets#edit'
  patch '/pets/:id', to: 'pets#update'
  delete '/pets/:id', to: 'pets#destroy'

  get 'admin/applications/:id', to: 'applications#show'



  get '/veterinary_offices', to: 'veterinary_offices#index'
  get '/veterinary_offices/new', to: 'veterinary_offices#new'
  get '/veterinary_offices/:id', to: 'veterinary_offices#show'
  post '/veterinary_offices', to: 'veterinary_offices#create'
  get '/veterinary_offices/:id/edit', to: 'veterinary_offices#edit'
  patch '/veterinary_offices/:id', to: 'veterinary_offices#update'
  delete '/veterinary_offices/:id', to: 'veterinary_offices#destroy'

  get '/veterinarians', to: 'veterinarians#index'
  get '/veterinarians/:id', to: 'veterinarians#show'
  get '/veterinarians/:id/edit', to: 'veterinarians#edit'
  patch '/veterinarians/:id', to: 'veterinarians#update'
  delete '/veterinarians/:id', to: 'veterinarians#destroy'

  get '/veterinary_offices/:veterinary_office_id/veterinarians', to: 'veterinary_offices#veterinarians'
  get '/veterinary_offices/:veterinary_office_id/veterinarians/new', to: 'veterinarians#new'
  post '/veterinary_offices/:veterinary_office_id/veterinarians', to: 'veterinarians#create'
end
