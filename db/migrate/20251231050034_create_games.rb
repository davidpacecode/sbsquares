class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.string :team_1
      t.string :team_2
      t.string :sport
      t.datetime :game_datetime
      t.string :status

      t.timestamps
    end
  end
end
