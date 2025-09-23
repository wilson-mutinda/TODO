class Api::V1::UsersController < ApplicationController

  # create_user
  def create_user
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

      # create_user
      created_user = User.create(
        created_user_info.merge({
          flag: 'Admin'
        })
      )

      if created_user
        render json: { message: "User created successfully!" }, status: :created
      else
        render json: { error: "Error creating user!", info: created_user.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view single_user
  def single_user
    begin
      user = User.find_by(id: params[:id])
      if user
        info = user.as_json(except: [:created_at, :updated_at, :password_digest])
        render json: info, status: :ok
      else
        render json: { error: "User not found!" }, status: :not_found
        return
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view all_users
  def all_users
    begin
      users = User.all
      if users.empty?
        render json: { error: "Empty List!" }, status: :not_found
        return
      else
        info = users.as_json(except: [:created_at, :updated_at, :password_digest])
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # update_user
  def update_user
    begin
      user = User.find_by(id: params[:id])
      if user
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
          if existing_email && existing_email.id != user.id
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
          if existing_phone && existing_phone.id != user.id
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

        # update_user
        updated_user = user.update(
          updated_user_info
        )
        if updated_user
          render json: { message: "User updated successfully!" }, status: :ok
        else
          render json: { error: "Error updating user!", info: user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "User not found!" }, status: :not_found
        return
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # delete_user
  def delete_user
    begin
      user = User.find_by(id: params[:id])
      if user
        user_email = user.email
        user_phone = user.phone

        user.destroy
        render json: { message: "User with phone #{user_phone} and email #{user_email} deleted successully!" }, status: :ok
      else
        render json: { error: "User not found!" }, status: :not_found
        return
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # user_login
  def user_login
    begin
      # email_param
      email_param = params[:email].to_s.gsub(/\s+/, '').downcase

      # password_param
      password_param = params[:password]

      user = User.find_by(email: email_param)
      if user
        auth = user.authenticate(password_param)
        if auth
          token = JsonWebToken
          flag = user.flag
          access_token = token.encode_token(user.id, user.flag, 30.minutes.from_now)
          refresh_token = token.encode_token(user.id, user.flag, 24.hours.from_now)

          UserLogin.send_login_email(user)
          render json: { 
            message: "Login successful",
            access_token: access_token,
            refresh_token: refresh_token,
            flag: flag,
          }, status: :ok
        else
          render json: { errors: { password: "Invalid password!"}}, status: :unprocessable_entity
          return
        end
      else
        render json: { errors: { email: "Email not found!"}}, status: :not_found
        return
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # refresh_token
  def refresh_token
        begin
          headers = request.headers['Authorization']
          if headers.blank?
            render json: { errors: { header: "Header cannot be blank!"}}, status: :unprocessable_entity
            return
          end

          refresh_token = headers.split( ).last

          decoded_token = JsonWebToken.decode_token(refresh_token)
          if decoded_token.present?
            user_id = decoded_token[:user_id]
            user_flag = decoded_token[:flag]

            new_access_token = JsonWebToken.encode_token(user_id, user_flag, 30.minutes.from_now)
            new_refresh_token = JsonWebToken.encode_token(user_id, user_flag, 24.hours.from_now)

            render json: { 
              new_access_token: new_access_token,
              new_refresh_token: new_refresh_token,
              user_flag: user_flag
            }, status: :ok
          end
        rescue => e
          render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
        end
        
  end

  # google_login
  require 'httparty'

  def google_login
    begin
      token = params[:token]

      # Verify the token with Google
      token_info = HTTParty.get("https://www.googleapis.com/oauth2/v3/tokeninfo?access_token=#{token}")
      
      if token_info.code != 200
        return render json: { error: "Invalid Google Token!" }, status: :unauthorized
      end

      # Verify the token is for your app
      if token_info['aud'] != ENV['GOOGLE_CLIENT_ID']
        return render json: { error: "Token audience mismatch!" }, status: :unauthorized
      end

      user_info = HTTParty.get("https://www.googleapis.com/oauth2/v3/userinfo",
        headers: { "Authorization" => "Bearer #{token}" })

      if user_info.code == 200
        email = user_info['email']
        name = user_info['name']

        user = User.find_or_create_by(email: email) do |u|
          u.name = name
          u.password = SecureRandom.hex(10)
        end

        access_token = JsonWebToken.encode_token(user.id, user.flag, 30.minutes.from_now)
        refresh_token = JsonWebToken.encode_token(user.id, user.flag, 24.hours.from_now)

        render json: { message: "Google Login Successful!", access_token: access_token, refresh_token: refresh_token, user: user }, status: :ok
      else
        render json: { error: "Invalid Google Token!" }, status: :unauthorized
      end
    rescue => e
      puts "Google login error: #{e.message}"
      puts e.backtrace
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # privately hold user_params
  private
  def user_params
    params.require(:user).permit(:email, :phone, :flag, :password, :password_confirmation)
  end
end
