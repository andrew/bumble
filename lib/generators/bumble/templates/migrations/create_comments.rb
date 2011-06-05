class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text     :body
      t.integer  :post_id
      t.integer  :user_id
      t.string   :author_name
      t.string   :author_email
      t.string   :author_url
      t.datetime :deleted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
