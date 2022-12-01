Rails.application.routes.draw do
  # get 'home/search'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#search'
  get '/' => 'home#search'
  get '/all' => 'home#search'
  get '/keyword/:keyword' => 'home#keyword'
  get '/user/:user' => 'home#user'
  # get '/alerter/:alerter' => 'home#alerter'
  get '/stats' => 'home#stat'
  get '/delete' => 'home#delete'
  post '/api/update_pharos' => 'api#update_pharos'
  post '/api/post_tweet' => 'api#post_tweet'
  get '/api/post_tweet' => 'api#post_tweet'
  delete '/delete/tweet' => 'home#delete_tweet'
  delete '/delete/user' => 'home#delete_user'
  delete '/add/tweet' => 'home#add_tweet'

end
