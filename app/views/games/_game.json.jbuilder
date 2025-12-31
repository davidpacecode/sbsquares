json.extract! game, :id, :team_1, :team_2, :sport, :game_datetime, :status, :created_at, :updated_at
json.url game_url(game, format: :json)
