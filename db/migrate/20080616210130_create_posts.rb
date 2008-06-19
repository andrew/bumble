class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.string :link_url
      t.string :image_url
      t.text :video_embed
      t.text :description
      t.text :quote
      t.string :permalink
      t.integer :user_id
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
