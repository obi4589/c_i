CI::Application.routes.draw do

  resources :password_resets
  match '/reset', to: 'password_resets#new', via: 'get'



  resources :activities do
    collection do
      get :me, :suggestions, :nearby
    end
  end

  resources :follows, only: [:create, :destroy] 

  resources :attendances, only: [:create, :destroy]

  resources :events do
    member do
      get :attendees, :friends
    end
    collection do
      get :go
    end
  end
  match '/new_event', to: "events#new", via: 'get'

  resources :superadmins, only: [:show] do
    member do
      get :index1, :index2
    end
  end

  resources :philanthropists do
    member do
      get :home, :followers, :following, :history, :change_password
      patch :active, :no_avatar, :update_password
    end
    collection do
      get :follow
    end
  end
  match '/signup1', to: 'philanthropists#new', via: 'get'


  resources :charities do
    member do
      get :home, :followers, :following, :about, :history, :change_password
      patch :active, :no_avatar, :update_password
    end
    collection do
      get :follow
    end
  end
  match '/signup2', to: 'charities#new', via: 'get' 

  
  resources :sessions, only: [:new, :create, :destroy]
  match '/login',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  
  
  root  'static_pages#root'
  match '/about',    to: 'static_pages#about',    via: 'get'
  match '/terms',   to: 'static_pages#terms',   via: 'get'
  match '/privacy', to: 'static_pages#privacy', via: 'get'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/inactive',    to: 'static_pages#inactive',    via: 'get'
  match '/allupcoming',    to: 'static_pages#all_upcoming',    via: 'get'
  match '/allhistory',    to: 'static_pages#all_history',    via: 'get'
  match '/allupcomingny',    to: 'static_pages#all_upcoming_ny',    via: 'get'
  match '/allhistoryny',    to: 'static_pages#all_history_ny',    via: 'get'
  


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
