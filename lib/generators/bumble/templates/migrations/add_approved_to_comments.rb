class AddApprovedToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :approved, :boolean, :default => true
    add_column :comments, :user_ip, :string
    add_column :comments, :user_agent, :string
    add_column :comments, :referrer, :string
  end

  def self.down
    remove_column :comments, :approved
    remove_column :comments, :user_ip
    remove_column :comments, :user_agent
    remove_column :comments, :referrer
  end
end
