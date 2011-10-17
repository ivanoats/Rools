require File.dirname(__FILE__) + '/../spec_helper'
require 'test/rules_errors_test'

describe "Rule Errors" do
  inherit RuleErrorsTest
  
  send('define_method', 'add_assertion', Proc.new{})    
  @_result = "unused"
  @_result.extend(self)
  
  
  it "rule execution should fail when an exception is encountered while evaluating a condition" do
     test_fail_condition
  end
  
  it "rule execution should fail when an exception is encountered while evaluating a consequence" do
     test_fail_consequence
  end
  
end
