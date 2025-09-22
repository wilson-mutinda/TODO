class Manager < ApplicationRecord
  belongs_to :user

  # validations
  validates :first_name, presence: true, if: -> { new_record? || first_name.present? }
  validates :last_name, presence: true, if: -> { new_record? || last_name.present? }
  validates :username, presence: true, if: -> { new_record? || username.present? }
  validates :company, presence: true, if: -> { new_record? || company.present? }
end
