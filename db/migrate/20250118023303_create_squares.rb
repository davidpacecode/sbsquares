class CreateSquares < ActiveRecord::Migration[8.0]
  def change
    create_table :squares do |t|
      t.integer :row
      t.integer :column
      t.references :board, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
