class Car < ApplicationRecord
  # Validations
  has_and_belongs_to_many :codes
  enum version: {
    original: 0,
    glp: 1,
    gnv3: 2,
    gnv4: 3,
    gnv5: 4,
    reforce: 5
  }
end
