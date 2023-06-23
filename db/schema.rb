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

ActiveRecord::Schema[7.0].define(version: 2023_06_18_074744) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "csrs", force: :cascade do |t|
    t.string "csr_number"
    t.text "csr_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "iatflists", force: :cascade do |t|
    t.string "iatf_number"
    t.text "iatf_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "iatfs", force: :cascade do |t|
    t.string "no"
    t.string "name"
    t.string "sales"
    t.string "process_design"
    t.string "production"
    t.string "inspection"
    t.string "release"
    t.string "procurement"
    t.string "equipment"
    t.string "measurement"
    t.string "policy"
    t.string "satisfaction"
    t.string "audit"
    t.string "corrective_action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phases", force: :cascade do |t|
    t.string "name"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "category"
    t.string "partnumber"
    t.string "materialcode"
    t.string "phase"
    t.string "stage"
    t.string "description"
    t.string "status"
    t.string "documenttype"
    t.string "documentname"
    t.string "documentrev"
    t.string "documentcategory"
    t.string "documentnumber"
    t.datetime "start_time"
    t.datetime "deadline_at"
    t.datetime "end_at"
    t.integer "goal_attainment_level"
    t.integer "tasseido"
    t.string "object"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "testmondais", force: :cascade do |t|
    t.string "kajyou"
    t.string "mondai_no"
    t.string "rev"
    t.string "mondai"
    t.string "mondai_a"
    t.string "mondai_b"
    t.string "mondai_c"
    t.string "seikai"
    t.string "kaisetsu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "touans", force: :cascade do |t|
    t.string "kajyou"
    t.string "mondai_no"
    t.string "rev"
    t.string "mondai"
    t.string "mondai_a"
    t.string "mondai_b"
    t.string "mondai_c"
    t.string "seikai"
    t.string "kaisetsu"
    t.string "kaito"
    t.integer "user_id"
    t.integer "total_answers"
    t.integer "correct_answers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "seikairitsu", default: 0.0
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "role"
    t.string "owner"
    t.string "auditor"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
