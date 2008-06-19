class AddDetailsToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :publicly_viewable, :boolean, :default => true
    add_column :posts, :published_at, :datetime
  end

  def self.down
    remove_column :posts, :published_at
    remove_column :posts, :publicly_viewable
  end
end
