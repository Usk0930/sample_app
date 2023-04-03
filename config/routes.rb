Rails.application.routes.draw do
  get 'users/signup', to: "users#new", as: 'signup'

  root "static_pages#home"
  # rootが設定されていれば、パスは自動で
  get  "/help",    to: "static_pages#help" # 例：help_path ⇨helpメソッドが複数あったらどう区別する？
  get  "/about",   to: "static_pages#about", as: 'ab'
  get  "/contact", to: "static_pages#contact"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
