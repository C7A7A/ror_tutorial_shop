Rails.application.routes.draw do
  get 'admin' => 'admin#index'

  controller :sessions do
    get     'login'   =>  :new
    post    'login'   =>  :create
    delete  'logout'  =>  :destroy
  end
  get 'sessions/create'
  get 'sessions/destroy'

  resources :users
  resources :products do
    get :who_bought, on: :member
  end

  scope '(:locale)' do
    resources :orders
    post 'orders/charge_client' => 'orders#charge_client'
    resources :line_items
    resources :carts
    root 'store#index', as: 'store_index', via: :all
  end

  get 'requests/positive_redirect' => 'requests#positive_redirect'
  get 'requests/negative_redirect' => 'requests#negative_redirect'

end
