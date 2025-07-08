
require 'jwt'

SECRET_KEY=ENV['SECRET_KEY']

class JsonWebToken
  
  # encode jwt token with user_id and exp duration
  def self.encode(user_id, exp=30.minutes.from_now)
    payload = {
      user_id: user_id,
      exp: exp.to_i
    }
    JWT.encode(payload, SECRET_KEY)
  end

  # decode token to get user_id
  def self.decode(token)
    decoded_token = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded_token)

  rescue JWT::DecodeError
    raise StandardError.new('Invalid Token')

  rescue JWT::ExpiredSignature
    raise StandardError.new('Expired Token')
  end
  
end
