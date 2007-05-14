#
# Testing Rools
#
# Pat Cappelaere
#
# Wed Apr 25 20:50:00 EDT 2007
#

require 'test/unit'
require 'rools'
require 'rools/base'
require 'logger'

    
class PriorityTest < Test::Unit::TestCase
  def setup
    #Rools::Base.logger = Logger.new(STDOUT)
  end

  def test_priority
    rules = Rools::RuleSet.new do
		rule('Prio1', 1) do
		    parameter String
			condition { $total == 6 }
			consequence { $total += 1 }
			consequence { puts "prio1: #{$total}" }
		end
		
		rule('Prio2', 2) do
		    parameter String
			condition { $total == 3 }
			consequence { $total *= 2 }
			consequence { puts "prio2: #{$total}" }
		end
		
		rule('Prio3', 3) do
		    parameter String
			condition { $total == 0 }
			consequence { $total = 3 }
			consequence { puts "prio3: #{$total}" }
		end
	end
	
	$total = 0
	status = rules.assert 'Heya'

	puts "rules.num_evaluated: #{rules.num_evaluated}"
	
	assert status == :pass
	assert rules.num_executed == 3
	assert rules.num_evaluated == 3
	assert $total == 7
  end
end
