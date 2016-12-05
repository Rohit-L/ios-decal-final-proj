Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/item/create', to: 'application#create_item'
  get '/item/read', to: 'application#read_item'
  post '/user/create', to: 'application#create_user'
  post '/image/upload', to: 'application#upload_image'
end
