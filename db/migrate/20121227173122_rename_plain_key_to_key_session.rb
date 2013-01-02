class RenamePlainKeyToKeySession < ActiveRecord::Migration
  def up
    rename_table :plain_keys, :key_sessions
  end

  def down
    rename_table :key_sessions, :plain_keys
  end
end
