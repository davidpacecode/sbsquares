class Game < ApplicationRecord
  has_many :quarter_scores, dependent: :destroy
  has_many :boards, dependent: :destroy
  validates :team_1, :team_2, :game_date, presence: true
  accepts_nested_attributes_for :quarter_scores

  after_create :create_quarter_scores

  private

  def create_quarter_scores
    4.times do |i|
      quarter_scores.create(team_1_score: 0, team_2_score: 0, quarter: i + 1)
    end
  end
end
