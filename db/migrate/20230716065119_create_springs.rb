class CreateSprings < ActiveRecord::Migration[7.0]
  def change
    create_table :springs do |t|
      t.float :wire
      t.float :dext
      t.float :dext2, null: true
      t.float :coils
      t.float :dint1, null: true
      t.float :dint2, null: true
      t.float :length
      t.references :code, null: false, foreign_key: true

      t.timestamps
    end
  end
end
