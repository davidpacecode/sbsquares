class Board < ApplicationRecord
  belongs_to :game
  has_many :squares, dependent: :destroy
  has_many :users, through: :squares
  
  validates :name, presence: true
  validates :square_price, presence: true, 
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
