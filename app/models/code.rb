class Code < ApplicationRecord
  has_and_belongs_to_many :cars
  has_one :spring
  enum position: {
    DEL: 0,
    POST: 1
  }

  enum version: {
    Original: 0,
    GLP: 1,
    GNV3: 2,
    GNV4: 3,
    GNV5: 4,
    Reforzado: 5,
    Progresivo: 6
  }
end
