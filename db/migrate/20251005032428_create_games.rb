class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.string :team_1
      t.string :team_2
      t.datetime :game_date

      t.timestamps
    end
  end
end
