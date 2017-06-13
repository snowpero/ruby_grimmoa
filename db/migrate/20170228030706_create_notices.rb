class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :title
      t.string :link
      t.string :writer
      t.date :created_on

      t.timestamps
    end
  end
end
