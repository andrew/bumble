class AddDeltaToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :delta, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :posts, :delta
  end
end
