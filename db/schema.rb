# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141006184355) do

  create_table "events", force: true do |t|
    t.integer  "charity_id"
    t.string   "title"
    t.date     "start_date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "location"
    t.text     "description"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "zip_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["charity_id", "start_date", "start_time"], name: "index_events_on_charity_id_and_start_date_and_start_time"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "zip_code"
    t.date     "birth_date"
    t.string   "legal_name"
    t.string   "ein"
    t.string   "contact_person"
    t.string   "phone"
    t.text     "mission"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
