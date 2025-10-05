class AddNumbersToGame < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :team_1_numbers, :string
    add_column :games, :team_2_numbers, :string
  end
end
