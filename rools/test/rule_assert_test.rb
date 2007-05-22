#
# Testing Rools
#
# Pat Cappelaere
#
# Tue May 22 11:03:01 EDT 2007
#

require 'test/unit'
require 'rools'
require 'rools/base'
require 'logger'

    
class RuleAssertTest < Test::Unit::TestCase
  def setup
    #Rools::Base.logger = Logger.new(STDOUT)
    
    @ruleset = Rools::RuleSet.new do
      rule "heya" do
        parameter String
        consequence { $result = "hello, Rools" }
      end
      
      rule "Fixnum" do
        parameter Fixnum
        condition { fixnum > 10 }
        consequence { assert("heya") }
      end
    end
  end
  
  def test_assert_1
    @ruleset.assert 5
    assert @ruleset.num_evaluated == 1
    assert @ruleset.num_executed == 0
  end
  
  def test_assert_1
    @ruleset.assert 25
    assert @ruleset.num_evaluated == 2
    assert @ruleset.num_executed == 2
  end
end
