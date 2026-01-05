class Square < ApplicationRecord
  belongs_to :user, optional: true  # Square can exist without being claimed
  belongs_to :board
  
  validates :row, :column, presence: true
  validates :row, inclusion: { in: 0..9 }
  validates :column, inclusion: { in: 0..9 }
  validates :nickname, length: { maximum: 50 }, allow_blank: true
  
  # Ensure no duplicate squares on the same board
  validates :row, uniqueness: { scope: [:board_id, :column] }
end
