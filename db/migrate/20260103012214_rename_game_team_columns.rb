class RenameGameTeamColumns < ActiveRecord::Migration[8.1]
  def change
    rename_column :games, :team_1, :home_team
    rename_column :games, :team_2, :away_team
  end
end
