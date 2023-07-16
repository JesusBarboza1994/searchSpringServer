class CreateCarsCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :cars_codes, id: false do |t|
      t.belongs_to :car
      t.belongs_to :code
    end
  end
end
