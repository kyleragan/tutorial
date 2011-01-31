Tutorial::Application.routes.draw do

resources :users


match '/contact', :to => 'pages#contact'
match '/about', :to => 'pages#about'
match '/help', :to => 'pages#help'
match 'home', :to => 'pages#home'

match '/signup', :to => 'users#new'

root :to => 'pages#home'



end
