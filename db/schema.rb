ActiveRecord::Schema.define(version: 2018_08_14_052714) do

  enable_extension "plpgsql"

  create_table "words", force: :cascade do |t|
    t.string "term"
    t.string "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
