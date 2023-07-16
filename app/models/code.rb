class Code < ApplicationRecord
  has_and_belongs_to_many :cars

  enum position: {
    front: 0,
    rear: 1
  }

  enum version: {
    original: 0,
    glp: 1,
    gnv3: 2,
    gnv4: 3,
    gnv5: 4,
    reforce: 5
  }
end
