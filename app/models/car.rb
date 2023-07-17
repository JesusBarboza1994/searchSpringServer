class Car < ApplicationRecord
  # Validations
  has_and_belongs_to_many :codes
  belongs_to :brand
end
