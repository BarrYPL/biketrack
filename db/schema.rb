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

ActiveRecord::Schema[7.0].define(version: 2023_10_22_164940) do
  create_table "bikes", force: :cascade do |t|
    t.string "bike_name"
    t.string "brand"
    t.integer "user_info_id"
    t.string "bike_id"
    t.boolean "primary", default: false
    t.integer "resource_state"
    t.float "distance"
    t.string "brand_name"
    t.string "bike_model_name"
    t.integer "frame_type"
    t.text "description", default: "Default Bike."
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chains", force: :cascade do |t|
    t.string "chain_name"
    t.datetime "vaxed_timestamp"
    t.datetime "instalation_date"
    t.integer "kmoffset"
    t.boolean "is_actually_used", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "chain_model"
    t.integer "bike_id"
  end

  create_table "rides", force: :cascade do |t|
    t.string "ride_name"
    t.float "distance"
    t.integer "athlete_id"
    t.integer "moving_time"
    t.integer "timestamp"
    t.string "gear_id"
    t.float "average_speed"
    t.float "max_speed"
    t.float "total_elevation_gain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ride_id"
    t.index ["ride_id"], name: "index_rides_on_ride_id", unique: true
  end

  create_table "user_infos", force: :cascade do |t|
    t.string "token_type"
    t.integer "expires_at"
    t.integer "expires_in"
    t.string "refresh_token"
    t.string "access_token"
    t.integer "athlete_id"
    t.string "athlete_username"
    t.integer "athlete_resource_state"
    t.string "athlete_firstname"
    t.string "athlete_lastname"
    t.string "athlete_bio"
    t.string "athlete_city"
    t.string "athlete_state"
    t.string "athlete_country"
    t.string "athlete_sex"
    t.boolean "athlete_premium"
    t.boolean "athlete_summit"
    t.datetime "athlete_created_at"
    t.datetime "athlete_updated_at"
    t.integer "athlete_badge_type_id"
    t.float "athlete_weight"
    t.string "athlete_profile_medium"
    t.string "athlete_profile"
    t.integer "athlete_friend_id"
    t.integer "athlete_follower_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
