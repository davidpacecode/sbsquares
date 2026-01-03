class RenameGameFinalScoresToQ4 < ActiveRecord::Migration[8.1]
  def change
    rename_column :games, :final_home, :q4_home
    rename_column :games, :final_away, :q4_away
  end
end
