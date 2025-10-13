class AddPriceToGame < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :square_price, :integer
  end
end
