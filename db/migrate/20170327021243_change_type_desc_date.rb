class ChangeTypeDescDate < ActiveRecord::Migration
  def change
    change_column :img_posts, :desc_date, :datetime
  end
end
