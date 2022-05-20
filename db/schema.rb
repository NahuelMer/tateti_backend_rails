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

ActiveRecord::Schema[7.0].define(version: 2022_05_13_172032) do
  create_table "board_players", id: false, force: :cascade do |t|
    t.string "chip"
    t.integer "board_id"
    t.integer "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_board_players_on_board_id"
    t.index ["player_id"], name: "index_board_players_on_player_id"
  end

  create_table "boards", force: :cascade do |t|
    t.json "cells", default: {"0"=>{"0"=>nil, "1"=>nil, "2"=>nil}, "1"=>{"0"=>nil, "1"=>nil, "2"=>nil}, "2"=>{"0"=>nil, "1"=>nil, "2"=>nil}}
    t.boolean "game_ended", default: false
    t.string "turn_name", default: "X"
    t.integer "turn_counter", default: 0
    t.string "board_code"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "player_name"
    t.string "password"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
