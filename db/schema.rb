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

ActiveRecord::Schema.define(version: 20170327021243) do

  create_table "img_posts", force: true do |t|
    t.string   "user_id"
    t.string   "post_date"
    t.string   "post_link"
    t.string   "post_thumb"
    t.string   "post_title"
    t.string   "site_info"
    t.string   "count_recommend"
    t.string   "count_reply"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "desc_date"
  end

  create_table "notices", force: true do |t|
    t.string   "title"
    t.string   "link"
    t.string   "writer"
    t.date     "created_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "post_type"
  end

end
