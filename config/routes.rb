Rails.application.routes.draw do

  devise_for :users
  resources :admins, except: [:destroy] do
    collection do
      post :invite_user
    end
  end

  scope path: ':organization_id' do

    resources :users
    resource :organization do
      collection do
        get :manage
      end
    end

    resources :adjustments
    resources :transfers, only: [:index, :create, :new, :show]
    resources :storage_locations do
      collection do
        post :import_csv
      end
      member do
        get :inventory
      end
    end

    resources :distributions, only: [:index, :create, :new, :show] do
      get :print, on: :member
      post :reclaim, on: :member
    end

    resources :barcode_items do
      get :find, on: :collection
    end
    resources :dropoff_locations do
      collection do
        post :import_csv
      end
    end
    resources :diaper_drive_participants, except: [:destroy] do
      collection do
        post :import_csv
      end
    end
    resources :items
    resources :partners do
      collection do
        post :import_csv
      end
    end


    resources :donations do
      collection do
        get :scale
        post :scale_intake
      end
      patch :add_item, on: :member
      patch :remove_item, on: :member
    end

    get 'dashboard', to: 'dashboard#index'

  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'pages/:name', to: 'static#page'
  root "static#index"
end
