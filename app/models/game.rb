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

  validates :q1_home, :q1_away, :q2_home, :q2_away, :q3_home, :q3_away, 
            :final_home, :final_away, 
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }, 
            allow_nil: true  

  # Default sport and status
  after_initialize :set_default_status_and_sport, if: :new_record?
  
  # Helper method to get score pairs
  def quarter_scores
    {
      q1: { home: q1_home, away: q1_away },
      q2: { home: q2_home, away: q2_away },
      q3: { home: q3_home, away: q3_away },
      final: { home: final_home, away: final_away }
    }
  end
  
  # Get last digit for a specific quarter
  def home_digit_for_quarter(quarter)
    send("#{quarter}_home")&.to_s&.last&.to_i
  end
  
  def away_digit_for_quarter(quarter)
    send("#{quarter}_away")&.to_s&.last&.to_i
  end

  private
  
  def set_default_status_and_sport
    self.status ||= 'scheduled'
    self.sport ||= 'nfl'
  end
end
