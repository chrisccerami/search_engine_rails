class CreateReverseIndices < ActiveRecord::Migration
  def change
    create_table :reverse_indices do |t|
      t.string :word
      t.integer :link_id
      t.timestamps null: false
    end

    add_index :reverse_indices, :word
  end
end
