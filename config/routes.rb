Rails.application.routes.draw do

  resources :players do
    resources :boards, only: [:create]
  end

  resources :boards, except: [:create] do
    member do
      post :join
    end
  end

end
