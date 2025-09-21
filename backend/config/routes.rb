Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
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
