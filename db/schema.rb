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

ActiveRecord::Schema[7.0].define(version: 2022_11_04_015718) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "ai_request_threads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ai_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type"
    t.uuid "session_id"
    t.jsonb "query"
    t.jsonb "response", default: {}
    t.text "response_text"
    t.integer "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "response_seconds", default: 0
    t.uuid "ai_request_thread_id_id"
    t.index ["ai_request_thread_id_id"], name: "index_ai_requests_on_ai_request_thread_id_id"
  end

  add_foreign_key "ai_requests", "ai_request_threads", column: "ai_request_thread_id_id"
end
