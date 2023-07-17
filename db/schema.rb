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

ActiveRecord::Schema[7.0].define(version: 2023_07_16_065140) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.string "img_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cars", force: :cascade do |t|
    t.string "model"
    t.integer "year"
    t.bigint "brand_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_cars_on_brand_id"
  end

  create_table "cars_codes", id: false, force: :cascade do |t|
    t.bigint "car_id"
    t.bigint "code_id"
    t.index ["car_id"], name: "index_cars_codes_on_car_id"
    t.index ["code_id"], name: "index_cars_codes_on_code_id"
  end

  create_table "codes", force: :cascade do |t|
    t.string "osis_code"
    t.string "url_img"
    t.integer "position", default: 1
    t.float "price"
    t.integer "init_year"
    t.integer "end_year"
    t.integer "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "springs", force: :cascade do |t|
    t.float "wire"
    t.float "dext"
    t.float "dext2"
    t.float "coils"
    t.float "dint1"
    t.float "dint2"
    t.float "length"
    t.bigint "code_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code_id"], name: "index_springs_on_code_id"
  end

  add_foreign_key "cars", "brands"
  add_foreign_key "springs", "codes"
end
