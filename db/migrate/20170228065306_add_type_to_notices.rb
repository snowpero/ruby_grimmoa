class AddTypeToNotices < ActiveRecord::Migration
  def change
    add_column :notices, :type, :string
  end
end
