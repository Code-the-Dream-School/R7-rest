Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :members do
        resources :facts
      end
    end
  end
end
