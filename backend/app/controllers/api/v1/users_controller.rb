class Api::V1::UsersController < ApplicationController

  # create_user
  def create_user
    begin
      # user_params in request body
      # email_param
      email_param = user_params[:email].to_s
      if email_param.blank?
        render json: { errors: { email: "Email should e provided!"}}, status: :unprocessable_entity
        return
      else
        # email_format
        email_format = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/
        unless email_param.match(email_format)
          render json: { errors: { email: "Invalid Email Format!"}}, status: :unprocessable_entity
          return
        end

        # email should not exist
        email = User.find_by(email: email_param)
        if email
          render json: { errors: { email: "Email Exixts!"}}, status: :unprocessable_entity
          return
        end
      end

      # phone_param
      phone_param = user_params[:phone].to_s
      if phone_param.blank?
        render json: { errors: { phone: "Phone Field required!"}}, status: :unprocessable_entity
        return
      else
        # phone_format
        phone_format = /\A(01|07)\d{8}\z/
        unless phone_param.match(phone_format)
          render json: { errors: { phone: "Invalid Phone Format!"}}, status: :unprocessable_entity
          return
        end

        # phone should not exist
        phone = User.find_by(phone: phone_param)
        if phone
          render json: { errors: { phone: "Phone Exixts!"}}, status: :unprocessable_entity
          return
        end
      end

      # password_param and password_confirmation_param
      password_param = user_params[:password]
      password_confirmation_param = user_params[:password_confirmation]

      if password_param.present? || password_confirmation_param.present?
        if !password_param || !password_confirmation_param
          render json: { errors: { password_confirmation: "Both password fields are required!"}}, status: :unprocessable_entity
          return
        end

        # password_format
        unless password_param.match(/\d/) && password_param.match(/[A-Za-z]/)
          render json: { errors: { password: "PAssword should have both alphabets and digits!"}}, status: :unprocessable_entity
          return
        end

        # password_mismatch
        if password_param.present? && password_confirmation_param.present? && password_param != password_confirmation_param
          render json: { errors: { password_confirmation: "Password Mismatch!"}}, status: :unprocessable_entity
          return
        end

        # password_length
        if password_param.length < 8
          render json: { errors: { password: "Password should have at least 8 characters"}}, status: :unprocessable_entity
          return
        end
      end

      # cretae_user
      created_user = User.create(
        email: email_param.to_s.downcase,
        phone: phone_param.to_s,
        password: password_param,
        password_confirmation: password_confirmation_param
      )

      if created_user
        render json: { message: "User Created!"}, status: :created
      else
        render json: { error: "Error creating user", info: created_user.errors.full_messages}, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # user_login
  def user_login
    begin

      email_param = params[:email].to_s
      password_param = params[:password]

      user = User.find_by(email: email_param)
      if user
        auth = user.authenticate(password_param)
        if auth
          access = JsonWebToken.encode(user.id, 30.minutes.from_now)
          refresh = JsonWebToken.encode(user.id, 24.hours.from_now)
          render json: {
            message: "Login Successful",
            access_token: access,
            refresh_token: refresh
          }
        else
          render json: { errors: { password: "Invalid Password!"}}, status: :unauthorized
        end
      else
        render json: { errors: { email: "Email Not Found!"}}, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # refresh_token
  def refresh_token
    begin
      header = request.headers['Authorization']
      if header
        refresh_token = header.split(' ').last
        decoded_token = JsonWebToken.decode(refresh_token)
        user_id = decoded_token[:user_id]

        new_acc_token = JsonWebToken.encode(user_id, 30.minutes.from_now)
        render json: {
          new_access_token: new_acc_token
        }
      else
        render json: { error: "Token Not Provided!"}, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # user_params in a private method
  private
  def user_params
    params.require(:user).permit(:email, :phone, :password, :password_confirmation)
  end

end
