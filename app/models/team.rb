class Team < ApplicationRecord
  has_one_attached :logo
  
  enum :sport, { nfl: 0, nba: 1, ncaa_football: 2, ncaa_basketball: 3 }
  
  validates :name, :city, :sport, presence: true
  
  def full_name
    "#{city} #{name}"
  end
end
