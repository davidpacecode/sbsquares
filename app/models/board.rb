class Board < ApplicationRecord
  belongs_to :game
  has_many :squares, dependent: :destroy
  validates :game_id, :name, :price, presence: true
  accepts_nested_attributes_for :squares

  after_create :create_squares

  private

  def create_squares
    (1..10).each do |i|
      (1..10).each do |j|
        squares.create(row: i, column: j)
      end
    end
  end
end
