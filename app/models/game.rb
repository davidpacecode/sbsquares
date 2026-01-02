class Game < ApplicationRecord
  # ActiveStorage attachments for team logos
  has_one_attached :team_1_logo
  has_one_attached :team_2_logo
  
  # Validations
  validates :team_1, :team_2, :sport, :game_datetime, presence: true
  validates :sport, inclusion: { in: %w[nfl ncaa_football ncaa_basketball nba], 
                                 message: "%{value} is not a valid sport" }
  validates :status, inclusion: { in: %w[scheduled in_progress completed cancelled],
                                  message: "%{value} is not a valid status" },
                     allow_nil: true

  # Default sport and status
  after_initialize :set_default_status_and_sport, if: :new_record?
  
  private
  
  def set_default_status_and_sport
    self.status ||= 'scheduled'
    self.sport ||= 'nfl'
  end
end
