# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
## db/seeds.rb
Team.create!([
  { city: "New York", name: "Jets", sport: :nfl },
  { city: "Buffalo", name: "Bills", sport: :nfl },
  { city: "Kansas City", name: "Chiefs", sport: :nfl },
  { city: "San Francisco", name: "49ers", sport: :nfl },
  { city: "Philadelphia", name: "Eagles", sport: :nfl },
  { city: "Los Angeles", name: "Lakers", sport: :nba },
  { city: "Boston", name: "Celtics", sport: :nba }
])
