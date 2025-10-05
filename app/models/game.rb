class Game < ApplicationRecord
  has_one_attached :team_1_logo
  has_one_attached :team_2_logo

  has_many :scores, dependent: :destroy
  has_many :squares, dependent: :destroy
  has_many :users, through: :squares

  after_create :create_squares

  private

  def create_squares
    (0..9).each do |row|
      (0..9).each do |column|
        squares.create!(row: row, column: column)
      end
    end
  end
end
