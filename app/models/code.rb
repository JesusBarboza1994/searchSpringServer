class Code < ApplicationRecord
  has_and_belongs_to_many :cars

  enum position: {
    front: 0,
    rear: 1
  }
end
