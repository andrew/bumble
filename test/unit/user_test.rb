require File.expand_path(File.dirname(__FILE__) + "/../test_helper.rb")

class UserTest < ActiveSupport::TestCase
  should_have_db_column :email, :crypted_password, :password_salt, :persistence_token, :type => :string, :null => false
  should_have_db_column :current_login_ip, :last_login_ip, :first_name, :last_name, :type => :string
  should_have_db_column :perishable_token, :type => :string

  should_have_db_columns :login_count, :failed_login_count, :type => :integer, :default => 0

  should_have_db_columns :last_request_at, :current_login_at, :last_login_at, :activated_at, :type => :datetime
  should_have_timestamps

  context "a user" do
    setup do
      @user = Factory.create(:user)
    end

    should_be_paranoid
    should_validate_presence_of :first_name

    should "update activated_at when activated" do
      @user.activate!
      assert @user.activated_at
    end
  end
  
  context "a new user" do
    setup do
      @user = Factory.create(:user)
    end

    should "not be activated" do
      assert_equal @user.activated_at, nil
    end
  end
  
end