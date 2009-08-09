class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email,                :null => false
      t.string :crypted_password,     :null => false
      t.string :password_salt,        :null => false
      t.string :persistence_token,    :null => false
      t.integer :login_count,         :null => false, :default => 0
      t.integer :failed_login_count,  :null => false, :default => 0
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip
      t.string :perishable_token
      t.datetime :deleted_at
      t.datetime :activated_at
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
