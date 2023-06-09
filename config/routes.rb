Rails.application.routes.draw do
  root to: 'pages#home'

  get "/search", to: "search#form"
  get "/search/results", to: "search#results"

  get "/pages/home", to: "pages#home"

  scope via: :all do
    get '/404', to: 'errors#not_found'
    get '/422', to: 'errors#unprocessable_entity'
    get '/429', to: 'errors#too_many_requests'
    get '/500', to: 'errors#internal_server_error'
  end
end
