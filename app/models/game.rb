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

    { s.team_1_name => team_1_score.to_s.last, s.team_2_name => team_2_score.to_s.last }

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
