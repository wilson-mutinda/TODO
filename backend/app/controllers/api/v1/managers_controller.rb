class Api::V1::ManagersController < ApplicationController
  # create_manager
  def create_manager
    begin
      # user_params
      created_user_info = {}
      # email_param
      email_param = user_params[:email].to_s.gsub(/\s+/, '').downcase
      if email_param.blank?
        render json: { errors: { email: "Email cannot be blank!"}}, status: :unprocessable_entity
        return
      else

        # email_format
        email_format = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/
        unless email_param.match?(email_format)
          render json: { errors: { email: "Invalid Email Format!"}}, status: :unprocessable_entity
          return
        end

        # email should not exist
        existing_email = User.find_by(email: email_param)
        if existing_email
          render json: { errors: { email: "Email already exists!"}}, status: :unprocessable_entity
          return
        end
        created_user_info[:email] = email_param
      end

      # phone_param
      phone_param = user_params[:phone].to_s.gsub(/\s+/, '')
      if phone_param.blank?
        render json: { errors: { phone: "Phone cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        # phone_format
        phone_format = /\A(2541|2547)\d{8}\z/
        unless phone_param.match?(phone_format)
          render json: { errors: { phone: "Invalid phone format!"}}, status: :unprocessable_entity
          return
        end

        # phone should not exist
        existing_phone = User.find_by(phone: phone_param)
        if existing_phone
          render json: { errors: { phone: "Phone already exists!"}}, status: :unprocessable_entity
          return
        end

        created_user_info[:phone] = phone_param
      end

      # password_param and password_confirmation_param
      password_param = user_params[:password]
      password_confirmation_param = user_params[:password_confirmation]

      if password_param.present? || password_confirmation_param.present?

        if password_param.present? && !password_confirmation_param
          render json: { errors: { passoword_confirmation: "Password confirmation required!"}}, status: :unprocessable_entity
          return
        elsif password_confirmation_param.present? && !password_param
          render json: { errors: { password: "Password required!"}}, status: :unprocessable_entity
          return
        end

        # password_mismatch
        if password_param.present? && password_confirmation_param.present? && password_param != password_confirmation_param
          render json: { errors: { password_confirmation: "Password Mismatch!"}}, status: :unprocessable_entity
          return
        end

        # password length
        if password_param.length < 8
          render json: { errors: { password: "Password should have at least 8 characters!"}}, status: :unprocessable_entity
          return
        end

        # password format
        unless password_param.match?(/[A-Za-z]/) && password_param.match?(/\d/)
          render json: { errors: { password: "Password should have both digits and letters!"}}, status: :unprocessable_entity
          return
        end
        created_user_info[:password] = password_param
        created_user_info[:password_confirmation] = password_confirmation_param
      end

      # manager_params
      created_manager_info = {}
      # first_name_param
      first_name_param = manager_params[:first_name].to_s.gsub(/\s+/, '').downcase
      if first_name_param.blank?
        render json: { errors: { first_name: "First name cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        first_name_param = first_name_param.to_s.gsub(/\s+/, '').capitalize
        created_manager_info[:first_name] = first_name_param
      end

      # last_name_param
      last_name_param = manager_params[:last_name].to_s.gsub(/\s+/, '').downcase
      if last_name_param.blank?
        render json: { errors: { last_name: "Last name cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        last_name_param = last_name_param.to_s.gsub(/\s+/, '').capitalize
        created_manager_info[:last_name] = last_name_param
      end

      # username_param
      username_param = manager_params[:username].to_s.gsub(/\s+/, '')
      if username_param.blank?
        render json: { errors: { username: "Username cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        # username should not exist
        existing_username = Manager.find_by(username: username_param)
        if existing_username
          render json: { errors: { username: "Username already exists!"}}, status: :unprocessable_entity
          return
        end
        username_param = username_param.to_s.gsub(/\s+/, '')
        created_manager_info[:username] = username_param
      end

      # company_param
      company_param = manager_params[:company]
      if company_param.blank?
        render json: { errors: { company: "Company cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        company_param = company_param.to_s.capitalize
        created_manager_info[:company] = company_param
      end

      # create_user
      created_user = User.create(
        created_user_info.merge({
          flag: 'Manager'
        })
      )

      if created_user
        # create_manager
        created_manager = Manager.create(
          created_manager_info.merge({
            user_id: created_user.id
          })
        )
        if created_manager
          render json: { message: "Manager created syucessfully!"}, status: :created
        else
          render json: { error: "Error creating manager!", info: created_manager.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Error creaing user!", info: created_user.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end
  
  # view single_manager
  def single_manager
    begin
      manager = Manager.find_by(id: params[:id])
      if manager
        manager_email = manager.user.email
        manager_phone = manager.user.phone
        flag = manager.user.flag
        info = manager.as_json(except: [:created_at, :updated_at]).merge({
          manager_email: manager_email,
          manager_phone: manager_phone,
          flag: flag
        })
        render json: info, status: :ok
      else
        render json: { error: "Manager not found!" }, status: :not_found
        return
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view all_managers
  def all_managers
    begin
      managers = Manager.all
      if managers.empty?
        render json: { error: "Empty List!"}, status: :not_found
        return
      else
        info = managers.map do |manager|
          manager_email = manager.user.email
          manager_phone = manager.user.phone
          flag = manager.user.flag
          manager.as_json(except: [:created_at, :updated_at]).merge({
            manager_email: manager_email,
            manager_phone: manager_phone,
            flag: flag
          })
        end
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # update_manager
  def update_manager
    begin
      manager = Manager.find_by(id: params[:id])
      if manager
        # user_params
        updated_user_info = {}
        # email_param
        email_param = user_params[:email].to_s.gsub(/\s+/, '').downcase
        if email_param.present?
          # email_format
          email_format = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
          unless email_param.match?(email_format)
            render json: { errors: { email: "Imvalid email format!"}}, status: :unprocessable_entity
            return
          end

          # email should not exist
          existing_email = User.find_by(email: email_param)
          if existing_email && existing_email.id != manager.user.id
            render json: { errors: { email: "Email already exists!"}}, status: :unprocessable_entity
            return
          end

          updated_user_info[:email] = email_param
        end

        # phone_param
        phone_param = user_params[:phone].to_s.gsub(/\s+/, '')
        if phone_param.present?
          # phone_format
          phone_format = /\A(2541|2547)\d{8}\z/
          unless phone_param.match?(phone_format)
            render json: { errors: { phone: "Invalid phone format!"}}, status: :unprocessable_entity
            return
          end

          # phone should not exist
          existing_phone = User.find_by(phone: phone_param)
          if existing_phone && existing_phone.id != manager.user.id
            render json: { errors: { phone: "Phone already exists!"}}, status: :unprocessable_entity
            return
          end

          updated_user_info[:phone] = phone_param
        end

        # password_param and password_confirmation_param
        password_param = user_params[:password]
        password_confirmation_param = user_params[:password_confirmation]

        if password_param.present? || password_confirmation_param.present?

          if password_param.present? && !password_confirmation_param
            render json: { errors: { passoword_confirmation: "Password confirmation required!"}}, status: :unprocessable_entity
            return
          elsif password_confirmation_param.present? && !password_param
            render json: { errors: { password: "Password required!"}}, status: :unprocessable_entity
            return
          end

          # password_mismatch
          if password_param.present? && password_confirmation_param.present? && password_param != password_confirmation_param
            render json: { errors: { password_confirmation: "Password Mismatch!"}}, status: :unprocessable_entity
            return
          end

          # password length
          if password_param.length < 8
            render json: { errors: { password: "Password should have at least 8 characters!"}}, status: :unprocessable_entity
            return
          end

          # password format
          unless password_param.match?(/[A-Za-z]/) && password_param.match?(/\d/)
            render json: { errors: { password: "Password should have both digits and letters!"}}, status: :unprocessable_entity
            return
          end
          updated_user_info[:password] = password_param
          updated_user_info[:password_confirmation] = password_confirmation_param
        end

        # manager_params
        updated_manager_info = {}
        # first_name_param
        first_name_param = manager_params[:first_name].to_s.gsub(/\s+/, '').downcase
        if first_name_param.present?
          first_name_param = first_name_param.to_s.gsub(/\s+/, '').capitalize
          updated_manager_info[:first_name] = first_name_param
        end

        # last_name_param
        last_name_param = manager_params[:last_name].to_s.gsub(/\s+/, '').downcase
        if last_name_param.present?
          last_name_param = last_name_param.to_s.gsub(/\s+/, '').capitalize
          updated_manager_info[:last_name] = last_name_param
        end

        # username_param
        username_param = manager_params[:username]
        if username_param.present?
          # username should not exist
          existing_username = Manager.find_by(username: username_param)
          if existing_username && existing_username.id != manager.id
            render json: { errors: { username: "USername already exists!"}}, status: :unprocessable_entity
            return
          end
          username_param = username_param
          updated_manager_info[:username] = username_param
        end

        # company_param
        company_param = manager_params[:company].to_s.gsub(/\s+/, '').downcase
        if company_param.present?
          company_param = company_param.to_s.gsub(/\s+/, '').capitalize
          updated_manager_info[:company] = company_param
        end

        # update_user
        updated_user = manager.user.update(
          updated_user_info
        )
        if updated_user
          # update_manager
          updated_manager = manager.update(
            updated_manager_info
          )
          if updated_manager
            render json: { message: "Manager updated successfully!" }, status: :ok
          else
            render json: { error: "Error updating manager!", info: manager.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: "Error updating user!", info: manager.user.errors.full_messages }, status: :unprocessable_entity
          return
        end
      else
        render json: { error: "Manager not found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # delete_manager
  def delete_manager
    begin
      manager = Manager.find_by(id: params[:id])
      if manager
        user = manager.user
        phone = user.phone
        username = manager.username
        # delete manager object first
        manager.destroy
        user.destroy
        render json: { message: "Manager with phone '#{phone}' and username '#{username}' deleted successfully!"}, status: :ok
      else
        render json: { error: "Manager not found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # privately hold user_params and manager_params
  private

  def user_params
    params.require(:user).permit(:email, :phone, :flag, :password, :password_confirmation)
  end

  def manager_params
    params.require(:manager).permit(:user_id, :first_name, :last_name, :username, :company)
  end
  
end
