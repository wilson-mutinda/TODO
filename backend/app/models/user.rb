class User < ApplicationRecord

  has_many :tasks
  # password_hashing
  has_secure_password

  # validations
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true
end
