class CreateBoards < ActiveRecord::Migration[8.1]
  def change
    create_table :boards do |t|
      t.string :name
      t.integer :square_price
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
