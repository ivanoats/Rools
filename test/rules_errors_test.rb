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

    
class RuleErrorsTest < Test::Unit::TestCase
  def setup
    #Rools::Base.logger = Logger.new(STDOUT)
  end
  
  def test_fail_condition
    # an exception will get generated when executing the condition
    # it is trapped and returns :FAIL
      ruleset = Rools::RuleSet.new do
		rule 'Hello' do
			parameter String
			condition {  1/0 }
			consequence { $result = "Hello, Rools!" }
		end
	  end
	  
	  status = ruleset.assert "hey"
	  assert status == Rools::RuleSet::FAIL
  end
  
   def test_fail_consequence
    # an exception will get generated when executing the consequence
    # it is trapped and returns :FAIL
      ruleset = Rools::RuleSet.new do
		rule 'Hello' do
			parameter String
			consequence { 1/0 }
		end
	  end
	  
	  status = ruleset.assert "hey"
	  assert status == Rools::RuleSet::FAIL
  end
  
end
