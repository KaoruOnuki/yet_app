class AddIndexTo < ActiveRecord::Migration[5.2]
  def change
    add_index :words, :term
    add_index :words, [:term, :user_id], unique: true
  end
end
