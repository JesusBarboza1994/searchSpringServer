class Car < ApplicationRecord
  # Validations
  has_and_belongs_to_many :codes
end
