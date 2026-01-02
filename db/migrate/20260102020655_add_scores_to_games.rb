class AddScoresToGames < ActiveRecord::Migration[8.1]
  def change
    add_column :games, :q1_home, :integer
    add_column :games, :q1_away, :integer
    add_column :games, :q2_home, :integer
    add_column :games, :q2_away, :integer
    add_column :games, :q3_home, :integer
    add_column :games, :q3_away, :integer
    add_column :games, :final_home, :integer
    add_column :games, :final_away, :integer
  end
end
