#
# Testing Rools
#
# Pat Cappelaere
#
# Tue May 22 22:14:08 EDT 2007
#

require 'test/unit'
require 'rools'
require 'rools/base'
require 'logger'

   
    class Employee
      attr_accessor :name
      def initialize( name)
        @name = name
      end
      def to_s
        return name
      end
    end
     
class RuleErrorsTest < Test::Unit::TestCase
  def setup
    #Rools::Base.logger = Logger.new(STDOUT)
  end
  
  def test_symbol
   
      ruleset = Rools::RuleSet.new do
		rule 'Hello' do
		    parameter String
			parameter Employee, :name
			consequence { puts "Hello, Rools!" }
		end
	  end
	  
	  status = ruleset.assert "heya"
	  assert ruleset.num_executed == 1
	  ruleset.delete_facts
	  
	  status = ruleset.assert Employee.new("pat")
	  assert ruleset.num_executed == 1
	  ruleset.delete_facts

	  status = ruleset.assert 49
	  assert ruleset.num_executed == 0
	 
  end
  
  def test_parameter_count
   ruleset = Rools::RuleSet.new do
	  rule 'Hello1' do
		parameter Fixnum
		consequence { $result = "Hello, Rools!" }
	  end
	  rule 'Hello2' do
	    consequence { $result = "Hello, Rools!" }
	  end
	end
	rules = ruleset.get_rules
	rule1 = rules.values[0]
	assert rule1.get_parameters.size == 1
	
	rule2 = rules.values[1]
	assert rule2.get_parameters.size == 0
  end
  

end
