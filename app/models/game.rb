class Game < ApplicationRecord
  has_one_attached :team_1_logo
  has_one_attached :team_2_logo
end
