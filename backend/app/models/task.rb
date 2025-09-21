class Task < ApplicationRecord

  # validations
  validates :task, presence: true
  validates :status, presence: true
end
