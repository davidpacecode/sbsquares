class Square < ApplicationRecord
  belongs_to :game
  belongs_to :user, optional: true

  validates :row, :column, presence: true, inclusion: { in: 0..9 }
  validates :row, uniqueness: { scope: [ :game_id, :column ] }
end
