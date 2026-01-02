module ApplicationHelper

  def sport_icon_tag(sport)
        icon_name = case sport
        when "nfl"
          "football"
        when "nba"
          "basketball"
        # ... etc
        else
          "trophy"
        end
        
    icon_name
  end
end

