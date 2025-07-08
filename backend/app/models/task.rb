class Task < ApplicationRecord
  belongs_to :user

  # validates
  validates :task, presence: true
end
