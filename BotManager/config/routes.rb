Rails.application.routes.draw do
  # get 'home/search'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#search'
  get '/' => 'home#search'
end