class AddIndexToLinks < ActiveRecord::Migration
  def change
    add_index :links, :url
  end
end
