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

ActiveRecord::Schema[7.0].define(version: 2025_05_21_120537) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "vector"

  create_table "ai_request_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "ai_request_id", null: false
    t.text "base64"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ai_request_id"], name: "index_ai_request_images_on_ai_request_id"
  end

  create_table "ai_request_threads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "session_id"
    t.text "full_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "messages", default: []
  end

  create_table "ai_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type"
    t.uuid "session_id"
    t.text "query"
    t.text "full_prompt"
    t.jsonb "response", default: {}
    t.text "response_text"
    t.integer "tokens_used"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "ai_request_thread_id"
    t.index ["ai_request_thread_id"], name: "index_ai_requests_on_ai_request_thread_id"
  end

# Could not dump table "help_articles" because of following StandardError
#   Unknown type 'vector' for column 'embedding'

# Could not dump table "memory_entries" because of following StandardError
#   Unknown type 'vector' for column 'embedding'

  add_foreign_key "ai_request_images", "ai_requests"
  add_foreign_key "ai_requests", "ai_request_threads"
end
