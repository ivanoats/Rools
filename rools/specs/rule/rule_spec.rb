require File.dirname(__FILE__) + '/../spec_helper'
require 'rools'

class Hour
  attr_accessor :val
  
  def initialize( val )
    @val = val
  end
  
  def > ( val)
    return @val >= val
  end
  
  def <= (val)
    @val <= val
  end
  
  def to_s
    @val.to_s
  end
end

describe Rools::Rule do

  it "should have a name that will be downcased" do
    ruleset = Rools::RuleSet.new do
		rule 'Hello' do
			parameter String
			consequence { $result = "Hello, Rools!" }
		end
	end
	rules = ruleset.get_rules
	rule = rules.values[0]
	rule.name.should eql("hello")
	rule.to_s.should eql("hello")
  end
  
  it "can have an optional priority" do
    ruleset = Rools::RuleSet.new do
		rule('Hello', 12) do
			parameter String
			consequence { $result = "Hello, Rools!" }
		end
	end
	rules = ruleset.get_rules
	rule = rules.values[0]
	rule.priority.should eql(12)
  end
  
  it "can have an optional parameter tag" do
    ruleset = Rools::RuleSet.new do
	  rule 'Hello1' do
		parameter String
		consequence { $result = "Hello, Rools!" }
	  end
	  rule 'Hello2' do
	    consequence { $result = "Hello, Rools!" }
	  end
	end
	rules = ruleset.get_rules
	rule1 = rules.values[0]
	rule1.parameters.should have(1).parameter
	
	rule2 = rules.values[1]
	rule2.parameters.should have(0).parameter
	
  end
  
  it "a rule parameter tag can define one or more types" do
    ruleset = Rools::RuleSet.new do
	  rule 'Hello1' do
		parameter String, Integer
		consequence { $result = "Hello, Rools!" }
	  end
	end
	
	rules = ruleset.get_rules
	rule1 = rules.values[0]
	rule1.parameters.should have(2).parameter
	
  end
  
  it "a rule parameter tage can define a Class type and a required method to respond to" do
    ruleset = Rools::RuleSet.new do
	  rule 'greater' do
		parameter Hour, :val
		condition { hour.val > 24}
		consequence { $result = "hour greater than 24" }
	  end
	end
	ruleset.assert Hour.new(56)
	ruleset.num_executed.should be(1)
  end
  
  it "a rule parameter type has to be pre-defined or will generate a RuleCheckError" do
    lambda {
      ruleset = Rools::RuleSet.new do
    	  rule 'Hello1' do
    		parameter Employee
    		consequence { $result = "Hello, Rools!" }
    	  end
	  end
	}.should raise_error(Rools::RuleCheckError)
	
  end
  
  it "should capture the rule name in a RuleCheckError" do
    begin
      ruleset = Rools::RuleSet.new do
    	  rule 'Hello1' do
    		parameter Employee
    		consequence { $result = "Hello, Rools!" }
    	  end
	  end
	rescue Rools::RuleCheckError => e
	  error = e.to_s
	  error.should eql("hello1\nuninitialized constant Employee")
	end
	
  end
  
  
  it "can have optional conditions" do
    ruleset = Rools::RuleSet.new do
	  rule 'greater' do
		parameter Hour
		condition { hour > 24}
		consequence { $result = "hour greater than 24" }
	  end
	  
	  rule 'pm' do
		parameter Hour
		condition { hour > 12}
		condition { hour < 24}
		consequence { $result = "in PM" }
	  end
	  
	  rule 'always' do
		consequence { $result = "always triggers" }
	  end  
	end
	
	rules = ruleset.get_rules
	rule1 = rules["greater"]
	rule1.conditions.should have(1).condition

	rule2 = rules["pm"]
	rule2.conditions.should have(2).conditions
	
	rule3 = rules["always"]
	rule3.conditions.should have(0).conditions
	
  end
  
  it "should have one or more consequences" do
    ruleset = Rools::RuleSet.new do
	  rule 'greater' do
		parameter Hour
		condition { hour > 24}
		consequence { $result = "hour greater than 24" }
	  end
	  
	  rule 'always' do
	    parameter Hour
		consequence { $result = "always triggers" }
		consequence { $result = "hour: #{hour}" }
	  end
	  
	end
	
	rules = ruleset.get_rules
	rule1 = rules["greater"]
	rule1.consequences.should have(1).consequence
	
	rule2 = rules["always"]
	rule2.consequences.should have(2).consequences
	
	status = ruleset.assert(Hour.new(30))
	status.should eql(Rools::RuleSet::PASS)
	ruleset.num_executed.should be(2);
    ruleset.num_evaluated.should be(2);
      
  end
end