class AddCostToSquare < ActiveRecord::Migration[8.0]
  def change
    add_column :squares, :price, :integer
  end
end
