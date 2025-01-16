class AddNumbersToBoard < ActiveRecord::Migration[8.0]
  def change
    add_column :boards, :row_numbers, :text
    add_column :boards, :column_numbers, :text
  end
end
