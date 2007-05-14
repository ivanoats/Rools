#
# Testing Rools
#
# Pat Cappelaere
#
# Thu May 10 12:33:00 EDT 2007
#

require 'test/unit'
require 'rools'
require 'rools/base'
require 'logger'

    
class MultiAssertTest < Test::Unit::TestCase
  def setup
    #Rools::Base.logger = Logger.new(STDOUT)
  end
  
  def test_multi_assert
    
    rules = Rools::RuleSet.new do
		rule 'Hello' do
			parameter String
			consequence { puts "hey, Rools!" + string + " float: #{float.to_s}"}
		end
	end
	
	begin
	rules.fact("Heya")
	rules.fact(12.3)
	#rules.fact("Hello")
	
	status = rules.evaluate
	assert true
	rescue Exception=>e
	 puts e.to_s
	 puts "failed multiple arguments to assert"
	 assert true
	end
	
  end
end