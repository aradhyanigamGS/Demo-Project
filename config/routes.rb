Rails.application.routes.draw do
  root 'main#index'
  get 'dashboard/index'


  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  # devise_scope :user do
  #   get '/users', to: 'devise/registrations#new'
  #   get '/users/password', to: 'devise/passwords#new'
  # end

  get 'confirmation_pending' => 'main#after_registration_path'


  resources :projects, param: :slug do
    member do
      get "remove_users"
    end
    resources :invitations, only: [:new, :create]
    resources :boards, param: :slug do
      resources :sprints, param: :slug do
        resources :tickets do
          member do
            patch :doing
            patch :testing
            patch :done
          end
        end
      end
    end
  end

  get '/projects/:project_id/boards/:id', to: "boards#index"
  # end

  get 'main/show', to: "main#show"
  get 'dashboard/index', to: "dashboard#index"
  get 'dashboard/project', to: "dashboard#project"
end
