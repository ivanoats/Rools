require File.dirname(__FILE__) + '/../spec_helper'
require 'test/rule_assert_test'

describe "Assertions in Rules" do
  inherit RuleAssertTest

  prepend_before(:each) {setup}

  send('define_method', 'add_assertion', Proc.new{})    
  @_result = "unused"
  @_result.extend(self)
 
  it "a rule should be able to assert a new object or fact" do
    test_assert_1
  end
  
end