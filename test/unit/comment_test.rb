require File.expand_path(File.dirname(__FILE__) + "/../test_helper.rb")

class CommentTest < ActiveSupport::TestCase

  should_have_db_columns :body, :type => :text
  should_have_db_column  :user_id, :post_id, :type => :integer
  should_have_timestamps

  context "a comment" do
    setup do
      @comment = Factory.create(:comment)
    end

    should_be_paranoid
    should_validate_presence_of :body
    should_belong_to :user
  end
end