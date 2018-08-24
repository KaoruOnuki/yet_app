class AddIndexToWords < ActiveRecord::Migration[5.2]
  def change
    add_index :words, [:term, :user_id], unique: true
  end
end
