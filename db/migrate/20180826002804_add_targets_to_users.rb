class AddTargetsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :target_of_the_day, :integer
    add_column :users, :target_of_the_week, :integer
    add_column :users, :target_of_the_month, :integer
  end
end
