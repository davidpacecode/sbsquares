class UpdateGameToUseTeams < ActiveRecord::Migration[8.1]
  def change
    # Add foreign keys to teams
    add_reference :games, :home_team, foreign_key: { to_table: :teams }
    add_reference :games, :away_team, foreign_key: { to_table: :teams }
    
    # Remove old columns
    remove_column :games, :home_team, :string
    remove_column :games, :away_team, :string
    
    # Remove logo attachments (happens in a separate step below)
  end
end
