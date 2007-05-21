require File.dirname(__FILE__) + '/../spec_helper'
require 'test/extend_test'

describe "Extending Rules" do
  inherit ExtendTest

  prepend_before(:each) {setup}

  send('define_method', 'add_assertion', Proc.new{})    
  @_result = "unused"
  @_result.extend(self)
 
 
  it "should allow rule extension" do
    test_extend_1
    test_extend_2
  end
  
  it "should allow user extension" do
    test_extend_user
  end
end