Rails.application.routes.draw do

  resources :players do
    resources :boards, only: [:create]
  end

  resources :boards, except: [:create]

  post 'boards/join'

end
