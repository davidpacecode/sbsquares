class Board < ApplicationRecord
  belongs_to :game
  has_many :squares, dependent: :destroy
  has_many :users, through: :squares
  
  validates :name, presence: true
  validates :square_price, presence: true, 
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  after_create :create_squares

  private

  def create_squares
    return if squares.exists?
  
    square_data = (0..9).flat_map do |row|
      (0..9).map { |column| { row: row, column: column, board_id: id } }
    end
  
    Square.insert_all(square_data)
  end
end
