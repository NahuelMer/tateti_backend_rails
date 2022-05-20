Rails.application.routes.draw do

  scope 'v1' do

    resources :players do
      resources :boards, only: [:create]
    end
  
    resources :boards, except: [:create]
    resources :sessions
  
    post 'boards/join'

    post 'players/login'
    
  end

end
