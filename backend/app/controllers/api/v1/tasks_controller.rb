class Api::V1::TasksController < ApplicationController

  # create_task
  def create_task
    begin
      # task_params
      # task_param
      task_param = task_params[:task]
      if task_param.blank?
        render json: { errors: { task: "Task cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        task_param = task_param
      end

      # create_task
      created_task = Task.create(
        task: task_param,
        status: 'Todo'
      )
      
      if created_task
        render json: { message: "Task created successfully!" }, status: :created
      else
        render json: { error: "Error creating task!", info: created_task.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view single_task
  def single_task
    begin
      task = Task.find_by(id: params[:id])
      if task
        info = task.as_json(except: [:created_at, :updated_at])
        render json: info, status: :ok
      else
        render json: { error: "Task not found!" }, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view all_undone_tasks
  def all_undone_tasks
    begin
      tasks = Task.where(status: 'Todo')
      if tasks.empty?
        render json: { error: "Empty List!" }, status: :not_found
        return
      else
        info = tasks.map do |task|
          task.as_json(except: [:created_at, :updated_at])
        end
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view all_doing_tasks
  def all_doing_tasks
    begin
      tasks = Task.where(status: 'Doing')
      if tasks.empty?
        render json: { error: "Empty List" }, status: :not_found
        return
      else
        info = tasks.map do |task|
          task.as_json(except: [:created_at, :updated_at])
        end
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message}, status: :internal_server_error
    end
    
  end

  # view all_done_tasks
  def all_done_tasks
    begin
      tasks = Task.where(status: 'Done')
      if tasks.empty?
        render json: { error: "Empty List" }, status: :not_found
        return
      else
        info = tasks.map do |task|
          task.as_json(except: [:created_at, :updated_at])
        end
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # update_task
  def update_task
    begin
      task = Task.find_by(id: params[:id])
      if task
        updated_task_info = {}
        # task_param
        task_param = task_params[:task]
        if task_param.present?
          task_param = task_param
          updated_task_info[:task] = task_param
        end

        # status_param
        status_param = task_params[:status].to_s.gsub(/\s+/, '')
        if status_param.present?

          # allowed_status
          allowed_status = ['Todo', 'Doing', 'Done']
          unless allowed_status.include?(status_param.to_s.gsub(/\s+/, '').capitalize)
            render json: { error: { status: "Invalid status! Please use '#{allowed_status.join(', ')}'"}}, status: :unprocessable_entity
            return
          end

          status_param = status_param.to_s.gsub(/\s+/, '').capitalize
          updated_task_info[:status] = status_param
        end

        # update_task
        updated_task = task.update(
          updated_task_info
        )

        if updated_task
          render json: { message: "Task updated successfully!" }, status: :ok
        else
          render json: { error: "Error updating task!", info: task.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Task not found!" }, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # delete_task
  def delete_task
    begin
      task = Task.find_by(id: params[:id])
      if task
        task.destroy
        render json: { message: "Task deleted successfully!" }, status: :ok
      else
        render json: { error: "Task not found!" }, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :unprocessable_entity
    end
    
  end

  # privately hold task_params
  private
  def task_params
    params.require(:task).permit(:task, :status)
  end
end
