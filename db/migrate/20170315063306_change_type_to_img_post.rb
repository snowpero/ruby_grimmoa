class ChangeTypeToImgPost < ActiveRecord::Migration
  def change
    change_column :img_posts, :count_recommend, :string
    change_column :img_posts, :count_reply, :string
  end
end
