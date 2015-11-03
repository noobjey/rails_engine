Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :customers, only: [:index, :show], defaults: { format: :json } do
        collection do
          get :find
          get :find_all
          get :random
        end
      end
    end
  end
end
