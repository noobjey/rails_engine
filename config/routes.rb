Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :customers, only: [:index, :show], defaults: { format: :json } do
        collection do
          get :find
          get :find_all
          get :random
        end

        member do
          get :invoices
          get :transactions
          get :favorite_merchant
        end
      end

      resources :merchants, only: [:index, :show], defaults: { format: :json } do
        collection do
          get :find
          get :find_all
          get :random
        end

        member do
          get :invoices
          get :items
          get :revenue
          get :favorite_customer
          get :customers_with_pending_invoices
        end
      end

      resources :items, only: [:index, :show], defaults: { format: :json } do
        collection do
          get :find
          get :find_all
          get :random
        end

        member do
          get :invoice_items
          get :merchant
        end
      end

      resources :invoices, only: [:index, :show], defaults: { format: :json } do
        collection do
          get :find
          get :find_all
          get :random
        end

        member do
          get :transactions
          get :invoice_items
          get :items
          get :customer
          get :merchant
        end
      end

      resources :invoice_items, only: [:index, :show], defaults: { format: :json } do
        collection do
          get :find
          get :find_all
          get :random
        end

        member do
          get :invoice
          get :item
        end
      end

      resources :transactions, only: [:index, :show], defaults: { format: :json } do
        collection do
          get :find
          get :find_all
          get :random
        end

        member do
          get :invoice
        end
      end
    end
  end
end
