class CreateImgPosts < ActiveRecord::Migration
  def change
    create_table :img_posts do |t|
      t.string :user_id
      t.string :post_date
      t.string :post_link
      t.string :post_thumb
      t.string :post_title
      t.string :site_info
      t.integer :count_recommend
      t.integer :count_reply

      t.timestamps
    end
  end
end
