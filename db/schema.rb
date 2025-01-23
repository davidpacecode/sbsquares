# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_01_23_050324) do
  create_table "boards", force: :cascade do |t|
    t.integer "game_id", null: false
    t.string "name"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "row_numbers"
    t.text "column_numbers"
    t.index ["game_id"], name: "index_boards_on_game_id"
  end

  create_table "boards_users", id: false, force: :cascade do |t|
    t.integer "board_id", null: false
    t.integer "user_id", null: false
  end

  create_table "games", force: :cascade do |t|
    t.string "team_1"
    t.string "team_2"
    t.date "game_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quarter_scores", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "quarter"
    t.integer "team_1_score"
    t.integer "team_2_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_quarter_scores_on_game_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "squares", force: :cascade do |t|
    t.integer "row"
    t.integer "column"
    t.integer "board_id", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "nickname"
    t.index ["board_id"], name: "index_squares_on_board_id"
    t.index ["user_id"], name: "index_squares_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "boards", "games"
  add_foreign_key "quarter_scores", "games"
  add_foreign_key "sessions", "users"
  add_foreign_key "squares", "boards"
  add_foreign_key "squares", "users"
end
