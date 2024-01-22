Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/cars', to: 'car#index'
  get '/codes', to: 'code#index'
  get '/codes/:id', to: 'code#show'
  get '/prueba', to: 'inventory#ejecutar_consulta'
  post '/codes', to: 'code#search'
end
