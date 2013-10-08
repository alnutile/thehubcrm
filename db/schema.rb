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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130905092916) do

  create_table "linked_in_settings", :force => true do |t|
    t.string   "key"
    t.string   "secret"
    t.datetime "synced_last"
    t.integer  "total_count"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "atoken"
    t.string   "asecret"
    t.string   "rtoken"
    t.string   "rsecret"
    t.string   "pin"
  end

  create_table "notes", :force => true do |t|
    t.string   "title"
    t.boolean  "task"
    t.date     "action_date"
    t.boolean  "reminder"
    t.text     "body"
    t.string   "related_profile_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "task_status",        :default => false
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image"
    t.string   "network_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "stars"
  end

end
