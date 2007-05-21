require File.dirname(__FILE__) + '/../spec_helper'
require 'rools'

# to support csv test
class Hour
end

describe "Empty RuleSet" do
  before(:each) do
    @ruleset = Rools::RuleSet.new
  end
  
  after(:each) do
    @ruleset = nil
  end
  
  it "should not contain any rules" do
    @ruleset.get_rules.size == 0
  end

  it "should not contain any facts" do
    @ruleset.get_facts.size == 0
  end
  
  it "responds to assert" do
    @ruleset.should respond_to(:assert)
  end
 
  it "can assert with one or more parameters" do
    obj1 = "heya"
    obj2 = 2
    #@ruleset.should_receive(:assert).with(obj1, obj2).and_return(Rools::RuleSet::PASS)
    status = @ruleset.assert(obj1, obj2)
    status.should equal(Rools::RuleSet::PASS)
  end
  
  it "responds to evaluate" do
    @ruleset.should respond_to(:evaluate)
  end
  
  it "has null metrics" do
    @ruleset.status == Rools::RuleSet::UNDETERMINED
    @ruleset.num_executed == 0
    @ruleset.num_evaluated == 0
  end
  
  it "can accept new facts programmatically and delete all facts" do
    obj1 = "heya"
    obj2 = 2
    @ruleset.fact( obj1 )
    @ruleset.fact( obj2 )
    
    @ruleset.get_facts.should have(2).facts
    @ruleset.delete_facts
    @ruleset.get_facts.should have(0).facts
  end
  
  it "can accept fact stements in a rule set" do
    @ruleset = Rools::RuleSet.new do
		facts 'Countries' do
			["China", "USSR", "France", "Great Britain", "USA"]
		end
	end
    @ruleset.get_facts.should have(1).fact
  end
  
  it "can load an xml file" do
    @ruleset.load_xml( "test/data/hello.xml")
    @ruleset.get_rules.should have(1).rule
  end
  
  it "can load an rb file" do
    @ruleset.load_rb( "test/data/hello.rb")
    @ruleset.get_rules.should have(1).rule
  end
  
  it "can load a csv file" do
    @ruleset.load_csv( "test/data/greetings.csv")
    @ruleset.get_rules.should have(4).rules
  end
  
end