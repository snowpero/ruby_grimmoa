class ChangeTypeName < ActiveRecord::Migration
  def change
    add_column :notices, :post_type, :string
  end
end
