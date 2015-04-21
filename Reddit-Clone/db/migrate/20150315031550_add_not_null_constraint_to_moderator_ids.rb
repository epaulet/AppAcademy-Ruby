class AddNotNullConstraintToModeratorIds < ActiveRecord::Migration
  def change
    change_column :subs, :moderator_id, :integer, null: false
  end
end
