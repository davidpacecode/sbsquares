class AddNumbersToBoard < ActiveRecord::Migration[8.1]
  def change
    add_column :boards, :home_team_numbers, :string, default: "??????????"
    add_column :boards, :away_team_numbers, :string, default: "??????????"
  end
end
