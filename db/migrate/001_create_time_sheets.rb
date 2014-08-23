class CreateTimeSheets < ActiveRecord::Migration
  def self.up
    create_table :time_sheets do |t|
      t.integer :user_id
      t.string :user_name
      t.string :date
      t.string :start_time
      t.string :end_time
      t.string :plan_item
      t.integer :real_minutes
      t.string :comments
      t.timestamps
    end
  end

  def self.down
    drop_table :time_sheets
  end
end
