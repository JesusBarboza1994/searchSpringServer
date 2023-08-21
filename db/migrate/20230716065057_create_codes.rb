class CreateCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :codes do |t|
      t.string :osis_code, unique: true
      t.string :img_url, null: true
      t.integer :position, default: 1
      t.float :price
      t.integer :version
      t.integer :table_id

      t.timestamps
    end
  end
end
