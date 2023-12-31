class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.string :model
      t.integer :init_year
      t.integer :end_year
      t.integer :table_id
      t.references :brand, null: false, foreign_key: true
      t.timestamps
    end
  end
end

