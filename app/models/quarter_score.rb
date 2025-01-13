class QuarterScore < ApplicationRecord
  belongs_to :game
  validates :game_id, :quarter, :team_1_score, :team_2_score, presence: true
end
