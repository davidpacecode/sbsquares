class CreateSquares < ActiveRecord::Migration[8.1]
  def change
    create_table :squares do |t|
      t.integer :row
      t.integer :column
      t.references :user, null: false, foreign_key: true
      t.references :board, null: false, foreign_key: true
      t.string :nickname

      t.timestamps
    end
  end
end
