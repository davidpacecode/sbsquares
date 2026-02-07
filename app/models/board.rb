class Board < ApplicationRecord
  belongs_to :game
  has_many :squares, dependent: :destroy
  has_many :users, through: :squares

  validates :name, presence: true
  validates :square_price, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  after_create :create_squares

  def home_digit_for(column)
    home_team_numbers[column]
  end

  def away_digit_for(row)
    away_team_numbers[row]
  end

  def randomize_numbers!
    update!(
      home_team_numbers: (0..9).to_a.shuffle.join,
      away_team_numbers: (0..9).to_a.shuffle.join
    )
  end

  def numbers_randomized?
    !home_team_numbers.include?("?")
  end

  def winning_square(home_digit, away_digit)
    [ home_team_numbers.index(home_digit.to_s), away_team_numbers.index(away_digit.to_s) ]
  end

  def winner(home_digit, away_digit)
    column_index = home_team_numbers.index(home_digit.to_s)
    row_index = away_team_numbers.index(away_digit.to_s)
    squares.find_by(row: row_index, column: column_index)&.user&.nickname
  end

  def cost_for_user(user)
    squares.where(user: user)&.count * square_price
  end

  private

  def create_squares
    return if squares.exists?

    square_data = (0..9).flat_map do |row|
      (0..9).map { |column| { row: row, column: column, board_id: id } }
    end

    Square.insert_all(square_data)
  end
end
