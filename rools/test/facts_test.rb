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

    
class FactsTest < Test::Unit::TestCase
  def setup
    Rools::Base.logger = Logger.new(STDOUT)
  end
  
  def test_facts
  	
	rules = Rools::RuleSet.new do
		
		facts 'Countries' do
			["China", "USSR", "France", "Great Britain", "USA"]
		end
		
		rule 'Is it on Security Council?' do
		  parameter String
			condition { countries.include?(string) }
			consequence { puts "Yes, #{string} is in the country list"}
		end
	end
	
	status = rules.assert 'France'
	assert status == :pass
	assert rules.num_executed == 1
	assert rules.num_evaluated == 1	
  end
	
  def test_one_fact
    rules = Rools::RuleSet.new do
		
		facts 'Actor' do
			["Reagan"]
		end
		
		rule 'Is it?' do
		  parameter String
			condition { actor == string}
			consequence { puts "Yes, #{string} is the famous actor"}
		end
	end
	
	status = rules.assert 'Reagan'
	assert status == :pass
	assert rules.num_executed == 1
	assert rules.num_evaluated == 1	
  end
  
  def test_range_fact
    rules = Rools::RuleSet.new do
		
		facts 'InvalidRange' do
			(9..12)
		end
		
		rule 'Invalid Number' do
		  parameter Fixnum
			condition { invalidrange.member?(fixnum) }
			consequence { puts "#{fixnum} is invalid"}
		end
	end
	
	status = rules.assert 10
	assert status == :pass
	assert rules.num_executed == 1
	assert rules.num_evaluated == 1	
  end
  
end