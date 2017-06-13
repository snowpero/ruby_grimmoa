class AddDescDateToImgPost < ActiveRecord::Migration
  def change
    add_column :img_posts, :desc_date, :date
  end
end
