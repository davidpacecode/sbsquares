class Board < ApplicationRecord
  belongs_to :game
  has_many :squares, dependent: :destroy
  has_and_belongs_to_many :users
  validates :game_id, :name, :price, presence: true
  accepts_nested_attributes_for :squares

  after_create :create_squares

  def update_selected_squares(square_ids, nickname)
    Rails.logger.info "Square IDs: #{square_ids.inspect}"
    Rails.logger.info "Nickname: #{nickname.inspect}"
    return unless square_ids.present? && nickname.present?
    squares.where(id: square_ids).update_all(nickname: nickname)
  end

  private

  def create_squares
    (1..10).each do |i|
      (1..10).each do |j|
        squares.create(row: i, column: j)
      end
    end
  end
end
