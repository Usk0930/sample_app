Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/signup', to: "users#new", as: 'signup'

  root "static_pages#home"
  # rootが設定されていれば、パスは自動で
  get  "/help",    to: "static_pages#help" # 例：help_path ⇨helpメソッドが複数あったらどう区別する？
  get  "/about",   to: "static_pages#about", as: 'ab'
  get  "/contact", to: "static_pages#contact"
  # loginでメソッド名がnewは気になるけどどういう命名？
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users
end
