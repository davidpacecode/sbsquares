class Game < ApplicationRecord
  has_one_attached :team_1_logo
  has_one_attached :team_2_logo

  has_many :scores, dependent: :destroy
  has_many :squares, dependent: :destroy
  has_many :users, through: :squares

  after_initialize :set_default_numbers, if: :new_record?
  after_create :create_squares
  after_create :create_scores

  def set_default_numbers
    self.team_1_numbers ||= "??????????"
    self.team_2_numbers ||= "??????????"
  end

  def randomize_numbers!
    self.team_1_numbers = (0..9).to_a.shuffle.join
    self.team_2_numbers = (0..9).to_a.shuffle.join
    save
  end

  def score (team)
    score = 0
    self.scores.each do |s|
      score += s.team_1_score if team == "team_1"
      score += s.team_2_score if team == "team_2"
    end
    score
  end

  def winning_numbers (quarter)
    team_1_score = 0
    team_2_score = 0

    self.scores.each do |s|
      team_1_score += s.team_1_score if s.quarter <= quarter
      team_2_score += s.team_2_score if s.quarter <= quarter
    end

    { self.team_1 => team_1_score.to_s.last, self.team_2 => team_2_score.to_s.last }

  end

  def winner (quarter)
    lookup_numbers = winning_numbers(quarter)
    team_1_digit = lookup_numbers[self.team_1]
    team_2_digit = lookup_numbers[self.team_2]

    # Find the position/index of the score digits in the randomized numbers
    column = self.team_1_numbers.index(team_1_digit)
    row = self.team_2_numbers.index(team_2_digit)

    winning_square = self.squares.find_by(column: column, row: row)
    user = User.find_by(id: winning_square&.user_id)
  end

  def is_locked?
    self.squares.where(user_id: nil).count == 0 ? true : false
  end

  def user_squares user_id
    squares = []
    self.squares.where(user_id: user_id).each_with_index do |square, index|
      squares[index] = [self.team_2_numbers[square.row], self.team_1_numbers[square.column]]
    end
    squares
  end

  private

  def create_squares
    (0..9).each do |row|
      (0..9).each do |column|
        squares.create!(row: row, column: column, price: square_price)
      end
    end
  end

  def create_scores
    (1..4).each do |q|
      scores.create!(quarter: q, team_1_score: 0, team_2_score: 0)
    end
  end
end
