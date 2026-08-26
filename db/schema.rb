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

ActiveRecord::Schema[8.1].define(version: 2026_08_26_173107) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "reservations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "decided_at"
    t.bigint "decided_by_id"
    t.datetime "ends_at", null: false
    t.string "purpose"
    t.bigint "room_id", null: false
    t.datetime "starts_at", null: false
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["decided_by_id"], name: "index_reservations_on_decided_by_id"
    t.index ["room_id", "starts_at", "ends_at"], name: "index_reservations_on_room_id_and_starts_at_and_ends_at"
    t.index ["room_id"], name: "index_reservations_on_room_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
    t.check_constraint "ends_at > starts_at", name: "reservations_ends_at_after_starts_at"
  end

  create_table "rooms", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "site_id", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_rooms_on_site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "address"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.string "role", default: "staff", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "reservations", "rooms"
  add_foreign_key "reservations", "users"
  add_foreign_key "reservations", "users", column: "decided_by_id"
  add_foreign_key "rooms", "sites"
end
