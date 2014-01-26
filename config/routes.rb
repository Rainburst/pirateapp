Myapp::Application.routes.draw do
  get '/pirate/:series/:season/:episode', to: 'pirate#download', as: "download"
  root :to => "home#index"
end
