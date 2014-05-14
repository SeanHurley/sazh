Sazh::Application.routes.draw do
  get "home/index"
  post "login/start"
  root :to => "home#index"
end
