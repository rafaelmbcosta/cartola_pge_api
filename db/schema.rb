# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_11_222621) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "awards", id: :serial, force: :cascade do |t|
    t.integer "award_type", null: false
    t.integer "dispute_month_id"
    t.integer "team_id", null: false
    t.integer "position"
    t.integer "season_id"
    t.float "prize", null: false
    t.integer "round_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "payed", default: false
    t.index ["dispute_month_id"], name: "index_awards_on_dispute_month_id"
    t.index ["round_id"], name: "index_awards_on_round_id"
    t.index ["season_id"], name: "index_awards_on_season_id"
    t.index ["team_id"], name: "index_awards_on_team_id"
  end

  create_table "battles", id: :serial, force: :cascade do |t|
    t.integer "round_id"
    t.boolean "first_win"
    t.float "first_points", default: 0.0
    t.boolean "draw"
    t.boolean "second_win"
    t.float "second_points", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "second_id"
    t.integer "first_id"
    t.index ["round_id"], name: "index_battles_on_round_id"
  end

  create_table "currencies", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.integer "round_id"
    t.float "difference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_currencies_on_round_id"
    t.index ["team_id"], name: "index_currencies_on_team_id"
  end

  create_table "dispute_months", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "season_id"
    t.string "details"
    t.string "dispute_rounds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "price", default: 30.0, null: false
    t.boolean "finished", default: false
    t.index ["season_id"], name: "index_dispute_months_on_season_id"
  end

  create_table "month_activities", id: :serial, force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "dispute_month_id", null: false
    t.boolean "active", null: false
    t.boolean "payed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "payed_value", default: 0.0
    t.index ["dispute_month_id"], name: "index_month_activities_on_dispute_month_id"
    t.index ["team_id"], name: "index_month_activities_on_team_id"
  end

  create_table "round_controls", id: :serial, force: :cascade do |t|
    t.boolean "generating_battles", default: false, null: false
    t.boolean "battles_generated", default: false, null: false
    t.datetime "battle_generated_date"
    t.boolean "updating_scores", default: false, null: false
    t.boolean "scores_updated", default: false, null: false
    t.datetime "scores_updated_date"
    t.integer "round_id"
    t.boolean "market_closed", default: false, null: false
    t.boolean "updating_league", default: false, null: false
    t.boolean "league_updated", default: false, null: false
    t.datetime "league_updated_date"
    t.boolean "updating_battle_scores", default: false, null: false
    t.boolean "battle_scores_updated", default: false, null: false
    t.datetime "battle_scores_update_date"
    t.boolean "generating_currencies", default: false, null: false
    t.boolean "currencies_generated", default: false, null: false
    t.datetime "currencies_generated_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "scores_created", default: false, null: false
    t.boolean "creating_scores", default: false, null: false
    t.index ["round_id"], name: "index_round_controls_on_round_id"
  end

  create_table "rounds", id: :serial, force: :cascade do |t|
    t.integer "number", null: false
    t.boolean "golden", default: false, null: false
    t.integer "season_id"
    t.date "market_open"
    t.datetime "market_close"
    t.boolean "finished", default: false, null: false
    t.integer "dispute_month_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dispute_month_id"], name: "index_rounds_on_dispute_month_id"
    t.index ["season_id"], name: "index_rounds_on_season_id"
  end

  create_table "rules", force: :cascade do |t|
    t.string "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "scores", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.string "team_name"
    t.string "player_name"
    t.integer "round_id"
    t.float "partial_score", default: 0.0
    t.float "final_score", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "players", default: 12
    t.index ["round_id"], name: "index_scores_on_round_id"
    t.index ["team_id"], name: "index_scores_on_team_id"
  end

  create_table "seasons", id: :serial, force: :cascade do |t|
    t.integer "year", null: false
    t.boolean "finished", default: false, null: false
    t.string "golden_rounds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", default: true, null: false
    t.string "slug"
    t.string "url_escudo_png"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "id_tag"
    t.string "player_name"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "awards", "dispute_months"
  add_foreign_key "awards", "rounds"
  add_foreign_key "awards", "seasons"
  add_foreign_key "awards", "teams"
  add_foreign_key "battles", "rounds"
  add_foreign_key "currencies", "rounds"
  add_foreign_key "currencies", "teams"
  add_foreign_key "month_activities", "dispute_months"
  add_foreign_key "month_activities", "teams"
  add_foreign_key "round_controls", "rounds"
  add_foreign_key "rounds", "dispute_months"
  add_foreign_key "rounds", "seasons"
  add_foreign_key "scores", "rounds"
  add_foreign_key "scores", "teams"
end
