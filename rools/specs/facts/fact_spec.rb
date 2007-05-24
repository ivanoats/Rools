require File.dirname(__FILE__) + '/../spec_helper'
require 'rools'

module FactTest
  class TestClass 
  end
end

describe Rools::Facts do
  before(:each) do
    p = Proc.new { "this is a fact" }
    @facts = Rools::Facts.new( nil, "String", p)
  end
  
  after(:each) do
    @facts = nil
  end
  
  it "should have a name" do
    @facts.name.should eql("String")
  end

  it "should have a value" do
    @facts.value.should eql("this is a fact")
  end
  
  it "should be printable" do
    @facts.to_s.should eql("facts: String this is a fact")
  end
  
  it "could have more than one value and contain an array of values" do
    p = Proc.new { ["a", "b", "c"] }
    @facts = Rools::Facts.new( nil, "Characters", p)
    @facts.value.class.to_s.should eql("Array")
  end
  
  it "a fact could have a namespace" do 
    ruleset = Rools::RuleSet.new
    ruleset.fact( FactTest::TestClass.new )
    # trick is that :: are substituted by __
    fact = ruleset.get_facts["facttest__testclass"]
    fact.name.should eql("facttest__testclass")
  end
end