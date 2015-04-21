class CreateSessions < ActiveRecord::Migration
  def change
    add_index :sessions, :session_token, unique: true
  end
end
