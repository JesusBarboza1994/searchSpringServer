class CreateCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :codes do |t|
      t.string :osis_code, unique: true
      t.string :url_img, null: true
      t.integer :position, default: 1
      t.float :price
      t.integer :init_year
      t.integer :end_year

      t.timestamps
    end
  end
end
