require File.expand_path(File.dirname(__FILE__) + "/../test_helper.rb")

class PostTest < ActiveSupport::TestCase

  should_have_db_columns :title, :permalink, :type => :string
  should_have_db_column  :user_id, :type => :integer
  should_have_timestamps

  context "a post" do
    setup do
      @post = Factory.create(:post)
    end

    should_be_paranoid
    should_validate_presence_of :user
    should_belong_to :user
  end
end