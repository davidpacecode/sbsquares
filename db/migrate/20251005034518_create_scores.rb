class CreateScores < ActiveRecord::Migration[8.0]
  def change
    create_table :scores do |t|
      t.references :game, null: false, foreign_key: true
      t.integer :quarter
      t.integer :team_1_score
      t.integer :team_2_score

      t.timestamps
    end
  end
end
