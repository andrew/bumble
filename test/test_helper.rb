ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require "authlogic/test_case"

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def self.should_have_timestamps
    should_have_db_columns :created_at, :updated_at, :type => :datetime
  end

  def self.should_accept_nested_attributes_for(*attr_names)
    klass = self.name.gsub(/Test$/, '').constantize

    context "#{klass}" do
      attr_names.each do |association_name|
        should "accept nested attrs for #{association_name}" do
          meth = "#{association_name}_attributes="
          assert  ([meth,meth.to_sym].any?{ |m| klass.instance_methods.include?(m) }),
                  "#{klass} does not accept nested attributes for #{association_name}"
        end
      end
    end
  end

  def self.should_have_attached_file(attachment)
    klass = self.name.gsub(/Test$/, '').constantize

    context "To support a paperclip attachment named #{attachment}, #{klass}" do
      should_have_db_column("#{attachment}_file_name",    :type => :string)
      should_have_db_column("#{attachment}_content_type", :type => :string)
      should_have_db_column("#{attachment}_file_size",    :type => :integer)
    end

    should "have a paperclip attachment named ##{attachment}" do
      assert klass.new.respond_to?(attachment.to_sym), "@#{klass.name.underscore} doesn't have a paperclip field named #{attachment}"
      assert_equal Paperclip::Attachment, klass.new.send(attachment.to_sym).class
    end
  end

  def self.should_be_paranoid
    klass = model_class
    should_have_db_column :deleted_at

    should "be paranoid (it will not be deleted from the database)" do
      # Removed so that it tests the model has declared is_paranoid
      # assert klass.is_paranoid
      assert klass.included_modules.include?(IsParanoid::InstanceMethods)
    end

    should "not have a value for deleted_at" do
      assert object = klass.find(:first)
      assert_nil object.deleted_at
    end

    context "when destroyed" do
      setup do
        assert object = klass.find(:first), "This context requires there to be an existing #{klass}"
        @deleted_id = object.id
        object.destroy
      end

      should "not be found" do
        assert_raise(ActiveRecord::RecordNotFound) { klass.find(@deleted_id) }
      end

      should "still exist in the database" do
        deleted_object = klass.find_with_destroyed(@deleted_id)
        assert_not_nil deleted_object.deleted_at
      end
    end
  end

  def self.should_be_denied_access(message = 'You must be logged in to do that!')
    should_set_the_flash_to message
    should_redirect_to('the login page') { login_url}
  end

  def dom_id(object)
    "#{object.class.to_s.downcase}_#{object.id}"
  end
end
