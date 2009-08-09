require 'test/unit'
require File.join(File.dirname(__FILE__), '../lib/permalink_fu')
require 'active_support/core_ext/class'

class FauxColumn < Struct.new(:limit)
end

module ActiveRecord
  class ActiveRecordError < StandardError; end
  class RecordNotFound < ActiveRecordError; end
end

class BaseModel
  def self.columns_hash
    @columns_hash ||= {'permalink' => FauxColumn.new(100), 'slug' => FauxColumn.new(100)}
  end

  include PermalinkFu
  attr_accessor :id
  attr_accessor :title
  attr_accessor :extra
  attr_reader   :permalink
  attr_accessor :foo

  cattr_accessor :validation
  
  def self.generated_methods
    @generated_methods ||= []
  end
  
  def self.primary_key
    :id
  end
  
  def self.logger
    nil
  end
  
  # ripped from AR
  def self.evaluate_attribute_method(attr_name, method_definition, method_name=attr_name)

    unless method_name.to_s == primary_key.to_s
      generated_methods << method_name
    end

    begin
      class_eval(method_definition, __FILE__, __LINE__)
    rescue SyntaxError => err
      generated_methods.delete(attr_name)
      if logger
        logger.warn "Exception occurred during reader method compilation."
        logger.warn "Maybe #{attr_name} is not a valid Ruby identifier?"
        logger.warn "#{err.message}"
      end
    end
  end

  def self.exists?(*args)
    false
  end

  def self.before_validation(method)
    self.validation = method
  end
  
  def self.find(*args)
    nil
  end

  def validate
    send self.class.validation
    permalink
  end
  
  def new_record?
    @id.nil?
  end
  
  def to_param
    @id
  end
  
  def write_attribute(key, value)
    instance_variable_set "@#{key}", value
  end
end

class MockModel < BaseModel
  def self.exists?(conditions)
    if conditions[1] == 'foo'   || conditions[1] == 'bar' || 
      (conditions[1] == 'bar-2' && conditions[2] != 2)
      true
    else
      false
    end
  end

  has_permalink :title
end

class MockModelUnique < BaseModel
  def self.exists?(conditions)
    if conditions[1] == 'foo'   || conditions[1] == 'bar' || 
      (conditions[1] == 'bar-2' && conditions[2] != 2)
      true
    else
      false
    end
  end

  has_permalink :title, :param => :permalink
end

class ScopedModel < BaseModel
  def self.exists?(conditions)
    if conditions[1] == 'foo' && conditions[2] != 5
      true
    else
      false
    end
  end

  has_permalink :title, :scope => :foo, :param => :permalink
end

class AsModel < BaseModel
  attr_reader   :slug
  has_permalink :title, :as => :slug
end

class OverrideParamModel < BaseModel
  has_permalink :title, :param => :permalink
end

class NoParamModel < BaseModel
  has_permalink :title, :param => false
end

class IfProcConditionModel < BaseModel
  has_permalink :title, :if => Proc.new { |obj| false }
end

class IfMethodConditionModel < BaseModel
  has_permalink :title, :if => :false_method
  
  def false_method; false; end
end

class IfStringConditionModel < BaseModel
  has_permalink :title, :if => 'false'
end

class UnlessProcConditionModel < BaseModel
  has_permalink :title, :unless => Proc.new { |obj| false }
end

class UnlessMethodConditionModel < BaseModel
  has_permalink :title, :unless => :false_method
  
  def false_method; false; end
end

class UnlessStringConditionModel < BaseModel
  has_permalink :title, :unless => 'false'
end

class MockModelExtra < BaseModel
  has_permalink [:title, :extra]
end

class ToSModel < BaseModel
  has_permalink

  def to_s
    @title.to_s
  end
end

class OptionsWithoutAttrsModel < BaseModel
  has_permalink :param => false

  def to_s
    @title.to_s
  end
end

class ParentModel < BaseModel
  has_permalink :title
end

class ChildModel < ParentModel
end

class ChildModelOverriding < ParentModel
  has_permalink

  def to_s
    'overriding'
  end
end

class PermalinkFuTest < Test::Unit::TestCase
  @@samples = {
    'This IS a Tripped out title!!.!1  (well/ not really)' => 'this-is-a-tripped-out-title1-well-not-really',
    '////// meph1sto r0x ! \\\\\\' => 'meph1sto-r0x',
    'āčēģīķļņūö' => 'acegiklnuo',
    '中文測試 chinese text' => 'chinese-text',
    "use what you\222ve got" => 'use-what-youve-got'
  }

  @@extra = { 'some-)()()-ExtRa!/// .data==?>    to \/\/test' => 'some-extra-data-to-test' }

  def test_should_escape_permalinks
    @@samples.each do |from, to|
      assert_equal to, PermalinkFu.escape(from)
    end
  end
  
  def test_should_escape_activerecord_model
    @m = MockModel.new
    @@samples.each do |from, to|
      @m.title = from; @m.permalink = nil
      assert_equal to, @m.validate
    end
  end

  def test_multiple_attribute_permalink
    @m = MockModelExtra.new
    @@samples.each do |from, to|
      @@extra.each do |from_extra, to_extra|
        @m.title = from; @m.extra = from_extra; @m.permalink = nil
        assert_equal "#{to}-#{to_extra}", @m.validate
      end
    end
  end
  
  def test_should_create_unique_permalink_only_when_param_equals_permalink
    @m = MockModel.new
    @m.permalink = 'foo'
    @m.validate
    assert_equal 'foo', @m.permalink
    
    @m.permalink = 'bar'
    @m.validate
    assert_equal 'bar', @m.permalink
    
    @m = MockModelUnique.new
    @m.permalink = 'foo'
    @m.validate
    assert_equal 'foo-2', @m.permalink
    
    @m.permalink = 'bar'
    @m.validate
    assert_equal 'bar-3', @m.permalink
  end
  
  def test_should_not_check_itself_for_unique_permalink
    @m = MockModelUnique.new
    @m.id = 2
    @m.permalink = 'bar-2'
    @m.validate
    assert_equal 'bar-2', @m.permalink
  end
  
  def test_should_create_unique_scoped_permalink
    @m = ScopedModel.new
    @m.permalink = 'foo'
    @m.validate
    assert_equal 'foo-2', @m.permalink

    @m.foo = 5
    @m.permalink = 'foo'
    @m.validate
    assert_equal 'foo', @m.permalink
  end
  
  def test_should_limit_permalink
    @old = MockModel.columns_hash['permalink'].limit
    MockModel.columns_hash['permalink'].limit = 2
    @m   = MockModel.new
    @m.title = 'BOO'
    assert_equal 'bo', @m.validate
  ensure
    MockModel.columns_hash['permalink'].limit = @old
  end
  
  def test_should_limit_unique_permalink
    @old = MockModelUnique.columns_hash['permalink'].limit
    MockModelUnique.columns_hash['permalink'].limit = 3
    @m   = MockModelUnique.new
    @m.title = 'foo'
    assert_equal 'f-2', @m.validate
  ensure
    MockModelUnique.columns_hash['permalink'].limit = @old
  end
  
  def test_should_use_custom_field
    @m = AsModel.new
    @m.title = 'stick this in "slug"'
    @m.validate
    assert_nil @m.permalink
    assert_not_nil @m.slug
  end
  
  def test_find_by_permalink
    assert_nil AsModel.find_by_permalink("permalink")
  end
  
  def test_find_by_permalink!
    assert_raises(ActiveRecord::RecordNotFound) { AsModel.find_by_permalink!("permalink") }
  end
  
  def test_should_abide_by_if_proc_condition
    @m = IfProcConditionModel.new
    @m.title = 'dont make me a permalink'
    @m.validate
    assert_nil @m.permalink
  end
  
  def test_should_abide_by_if_method_condition
    @m = IfMethodConditionModel.new
    @m.title = 'dont make me a permalink'
    @m.validate
    assert_nil @m.permalink
  end
  
  def test_should_abide_by_if_string_condition
    @m = IfStringConditionModel.new
    @m.title = 'dont make me a permalink'
    @m.validate
    assert_nil @m.permalink
  end
  
  def test_should_abide_by_unless_proc_condition
    @m = UnlessProcConditionModel.new
    @m.title = 'make me a permalink'
    @m.validate
    assert_not_nil @m.permalink
  end
  
  def test_should_abide_by_unless_method_condition
    @m = UnlessMethodConditionModel.new
    @m.title = 'make me a permalink'
    @m.validate
    assert_not_nil @m.permalink
  end
  
  def test_should_abide_by_unless_string_condition
    @m = UnlessStringConditionModel.new
    @m.title = 'make me a permalink'
    @m.validate
    assert_not_nil @m.permalink
  end
  
  def test_should_optionally_override_to_param
    @m = OverrideParamModel.new
    @m.permalink = 'My Param'
    @m.validate
    assert_equal 'my-param', @m.to_param
    
    @m = NoParamModel.new
    @m.permalink = 'My Param'
    @m.validate
    assert_not_equal 'my-param', @m.to_param
  end
  
  def test_should_override_to_param_by_default
    @m = MockModel.new
    @m.permalink = 'My Param'
    @m.id = 1
    @m.validate
    assert_equal '1-my-param', @m.to_param
    
    @m = MockModel.new
    @m.permalink = ''
    @m.id = 1
    @m.validate
    assert_equal 1, @m.to_param
  end

  def test_should_rely_on_to_s_if_no_attr_given
    @m = ToSModel.new
    @m.title = 'Will rely on to_s'
    @m.validate
    assert_equal 'will-rely-on-to_s', @m.permalink
    
    @m = OptionsWithoutAttrsModel.new
    @m.title = 'Will rely on to_s'
    @m.validate
    assert_equal 'will-rely-on-to_s', @m.permalink
  end

  def test_should_work_with_sti
    @m = ChildModel.new
    @m.title = 'This is a child'
    @m.validate
    assert_equal 'this-is-a-child', @m.permalink
    
    @m = ChildModelOverriding.new
    @m.title = 'This is a child'
    @m.validate
    assert_equal 'overriding', @m.permalink
  end

end
