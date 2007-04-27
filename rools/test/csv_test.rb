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

class Customer
  attr_accessor :name, :gender, :maritalStatus
  
  def initialize(name, gender, maritalStatus)
    @name          = name
    @gender        = gender
    @maritalStatus = maritalStatus
  end
end

class CSVTest < Test::Unit::TestCase

  def setup
    #Rools::Base.logger = Logger.new(STDOUT)
  end
  
  def no_test_greetings
    rules  = Rools::RuleSet.new 'test/data/greetings.csv'
	status = rules.assert 1
	assert status == :pass
	assert $greeting = "Good Morning"
	
	status = rules.assert 13
	assert status == :pass
	assert $greeting = "Good Afternoon"
	
	status = rules.assert 19
	assert status == :pass
	assert $greeting = "Good Night"
  end
	
  def test_salutations
    sally = Customer.new("sally", "Married", 43)
    peggy = Customer.new("peggy", "Single", 43)
    joe = Customer.new("Joe", "Single", 43)
    john = Customer.new("Little John", "Single", 9)
    
    rules  = Rools::RuleSet.new 'test/data/salutations.csv'
	status = rules.assert sally
	assert status == :pass
	assert $salutation = "Mrs."
	
	status = rules.assert peggy
	assert status == :pass
	assert $salutation = "Ms."
	
	status = rules.assert joe
	assert status == :pass
	assert $salutation = "Mr."

	status = rules.assert john
	assert status == :pass
	assert $salutation = "Little"

  end
end