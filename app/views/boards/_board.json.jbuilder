json.extract! board, :id, :name, :square_price, :game_id, :created_at, :updated_at
json.url board_url(board, format: :json)
