class AddTeamColorsToGame < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :team_1_color, :string
    add_column :games, :team_2_color, :string
  end
end
