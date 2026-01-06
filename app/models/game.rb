class Game < ApplicationRecord
  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'
  has_many :boards, dependent: :destroy
  
  validates :home_team, :away_team, :game_datetime, presence: true
  
  validates :status, inclusion: { in: %w[scheduled in_progress completed],
                                  message: "%{value} is not a valid status" },
                     allow_nil: true

  validates :q1_home, :q1_away, :q2_home, :q2_away, :q3_home, :q3_away, 
            :q4_home, :q4_away, 
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }, 
            allow_nil: true  

  # Default status
  after_initialize :set_default_status, if: :new_record?

  def sport
    home_team&.sport
  end
  
  # Helper method to get score pairs
  def quarter_scores
    {
      q1: { home: q1_home, away: q1_away },
      q2: { home: q2_home, away: q2_away },
      q3: { home: q3_home, away: q3_away },
      q4: { home: q4_home, away: q4_away }
    }
  end
  
  # Get last digit for a specific quarter
  def home_digit_for_quarter(quarter)
    send("#{quarter}_home")&.to_s&.last&.to_i
  end
  
  def away_digit_for_quarter(quarter)
    send("#{quarter}_away")&.to_s&.last&.to_i
  end

  def title
    "#{game_datetime.strftime('%B %-d, %Y')} at #{home_team&.name} vs #{away_team&.name}"
  end

  private
  
  def set_default_status
    self.status ||= 'scheduled'
  end
end
