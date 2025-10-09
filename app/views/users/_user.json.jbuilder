json.extract! user, :id, :email_address, :first_name, :last_name, :nickname, :role, :created_at, :updated_at
json.url user_url(user, format: :json)
