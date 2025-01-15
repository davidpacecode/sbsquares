class CreateBoards < ActiveRecord::Migration[8.0]
  def change
    create_table :boards do |t|
      t.references :game, null: false, foreign_key: true
      t.string :name
      t.integer :price

      t.timestamps
    end
  end
end
