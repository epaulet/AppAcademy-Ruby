class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.integer :author_id
      t.string :title
      t.timestamps null: false
    end
    add_index :polls, :author_id
  end
end
