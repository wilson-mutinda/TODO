Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      # user
      post 'create_user', to: 'users#create_user'
      get 'single_user/:id', to: 'users#single_user'
      get 'all_users', to: 'users#all_users'
      patch 'update_user/:id', to: 'users#update_user'
      delete 'delete_user/:id', to: 'users#delete_user'

      post 'user_login', to: 'users#user_login'
      post 'refresh_token', to: 'users#refresh_token'

      # task
      post 'create_task', to: 'tasks#create_task'
      
      get 'single_task/:id', to: 'tasks#single_task'
      get 'all_undone_tasks', to: 'tasks#all_undone_tasks'
      get 'all_doing_tasks', to: 'tasks#all_doing_tasks'
      get 'all_done_tasks', to: 'tasks#all_done_tasks'
      
      patch 'update_task/:id', to: 'tasks#update_task'
      delete 'delete_task/:id', to: 'tasks#delete_task'
    end
  end
end
