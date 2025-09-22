require 'jwt'
SECRET_KEY = ENV['SECRET_KEY']

class JsonWebToken
  # encode token with user_id, flag and exp
  def self.encode_token(user_id, flag, exp = 30.minutes.from_now)
    payload = {
      user_id: user_id,
      flag: flag,
      exp: exp.to_i
    }
    JWT.encode(payload, SECRET_KEY)
  end

  # decode_token to get user_id, flag, and exp
  def self.decode_token(token)
    begin
      decoded_token = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new(decoded_token)
    rescue JWT::ExpiredSignature
      raise StandardError, 'Token has expired'
    rescue JWT::DecodeError
      raise StandardError, 'Invalid token'
    end 
  end
end