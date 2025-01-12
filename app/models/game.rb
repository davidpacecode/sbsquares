class Game < ApplicationRecord
  validates :team_1, :team_2, :game_date, presence: true
end
