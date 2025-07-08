Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # users
      post 'create_user/', to: 'users#create_user'

      # user_login
      post 'user_login/', to: 'users#user_login'

      # refresh_token
      get 'refresh_token/', to: 'users#refresh_token'

      # tasks
      post 'create_task', to: 'tasks#create_task'
      get 'single_task/:id/', to: 'tasks#single_task'
      get 'all_tasks/', to: 'tasks#all_tasks'
      patch 'update_task/:id/', to: 'tasks#update_task'
      delete 'delete_task/:id/', to: 'tasks#delete_task'
    end
  end
end
