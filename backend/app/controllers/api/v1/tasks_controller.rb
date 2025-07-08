class Api::V1::TasksController < ApplicationController

  before_action :get_user_id

  # create_task
  def create_task
    begin
      # task_param
      task_param = task_params[:name]
      if task_param.blank?
        render json: { errors: { name: "Task Required!"}}, status: :unprocessable_entity
        return
      else
        task_param = task_param.capitalize
      end

      # create_task
      created_task = Task.create(
        task:task_param,
        user_id: @user_id,
        status: 'todo'
      )
      if created_task
        render json: { message: "Task Created"}, status: :created
      else
        render json: { error: "Error creating task", info: created_task.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # fetch single_task
  def single_task
    begin
      task = Task.find_by(id: params[:id])
      if task
        user = task.user.email
        info  = task.as_json(except: [:created_at, :updated_at, :user_id]).merge({ user: user})
        render json: info, status: :ok
      else
        render json: { error: "Task Not Found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # fetch all_tasks
  def all_tasks
    begin
      tasks = Task.all 
      if tasks.empty?
        render json: { error: "Empty List!"}, status: :not_found
      else
        info = tasks.map do |task|
          user = task.user.email
        task.as_json(except: [:created_at, :updated_at, :user_id]).merge({ user: user})          
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
        # task param from request body
        task_param = task_params[:name]
        status_param = task_params[:status]
        update_data = {}

        if task_param.present?
          update_data[:task] = task_param.capitalize
        end

        if status_param.present?
          update_data[:status] = status_param
        end

        # update_task
        updated_task = task.update(update_data)
        
        if updated_task
          render json: { message: "Task Updated!"}, status: :ok
        else
          render json: { error: "Error Updating Task", info: updated_task.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Task Not Found!"}, status: :not_found
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
        user = task.user.email
        task.destroy
        render json: { message: "Task by '#{user}' deleted"}, status: :ok
      else
        render json: { error: "Task Not Found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :status)
  end

  # get user_id from access_token
  def get_user_id
    headers = request.headers['Authorization']
    if headers
      access_token = headers.split(' ').last
      decoded_token = JsonWebToken.decode(access_token)
      @user_id = decoded_token[:user_id]
    else
      render json: { error: "No Token!"}, status: :unauthorized
    end
  end
end
