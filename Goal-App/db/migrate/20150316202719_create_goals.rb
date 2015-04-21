class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :body
      t.references :user, index: true
      t.boolean :completed
      t.boolean :is_private

      t.timestamps null: false
    end
    add_foreign_key :goals, :users
  end
end
