class AddIndexToWordsTerm < ActiveRecord::Migration[5.2]
  def change
    add_index :words, :term, unique: true
  end
end
