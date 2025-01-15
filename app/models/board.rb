class Board < ApplicationRecord
  belongs_to :game
  validates :game_id, :name, :price, presence: true
end
