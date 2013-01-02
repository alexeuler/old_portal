Portal::Application.routes.draw do
  get "login_panel/show"

  devise_for :users,  :controllers => { :omniauth_callbacks => "users/omniauth_callbacks"}

  resources :topics, :except => [:index]
  resources :board_groups, :except => [:show, :index]
  resources :boards, :except=>:show

  root :to => 'home#index', :as => '/'
  
end
