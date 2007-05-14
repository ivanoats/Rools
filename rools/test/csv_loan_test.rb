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
  
  attr_accessor :fullName,	:ssn,	:monthlyIncome,	:monthlyDebt,	:mortgageHolder
  attr_accessor :outsideCreditScore, :loanHolder,	:creditCardBalance,	:educationLoanBalance
  attr_accessor :internalCreditRating,	:internalAnalystOpinion
  
  
  def initialize(fullName,sn,monthlyIncome,	monthlyDebt,mortgageHolder,	outsideCreditScore,	
      loanHolder,	creditCardBalance,	educationLoanBalance,	internalCreditRating,	
      internalAnalystOpinion)
      
    @fullName             = fullName	
    @ssn                  = ssn
    @monthlyIncome        =	monthlyIncome
    @monthlyDebt	      = monthlyDebt
    @mortgageHolder	      = mortgageHolder
    @outsideCreditScore   = outsideCreditScore
    @loanHolder           =	loanHolder
    @creditCardBalance    =	creditCardBalance	
    @educationLoanBalance = educationLoanBalance	
    @internalCreditRating = internalCreditRating	
    @internalAnalystOpinion  = internalAnalystOpinion
  end
end

class LoanRequest
  attr_accessor :customer,	:amount,	:purpose,	:term
  
  def initialize( customer, amount, purpose, term )
    @customer = customer
    @amount   = amount
    @purpose  = purpose
    @term     = term
  end
end

class CSVLoanTest < Test::Unit::TestCase

  def setup
    #Rools::Base.logger = Logger.new(STDOUT)
    
    @customer1 = Customer.new("Peter N. Johnson", "157-82-5344",	5000,	2300,	"Yes",	720,	"No",	2500.78,	0,	"B",	"Low")
    @customer2 = Customer.new("Mary K. Brown",	"056-45-8233",	4300,	1800,	"No",	620,	"No",	2500.78,	23800,	"C",	"Low")
    @customer3 = Customer.new("Robert Cooper Jr.",	"241-56-9082",	6400,	2800,	"Yes",	735,	"Yes",	1200,	0,	"A",	"Mid")

    @loan1 = LoanRequest.new("Peter N. Johnson",	30000,	"Education", 72)
    @loan2 = LoanRequest.new("Mary K. Brown",	40000,	"Second Mortgage", 36)
  end
  
  def test_rules_101
    rules  = Rools::RuleSet.new 'test/data/rules101.csv'
	status = rules.assert @customer1, @loan1
	#puts "$incomeValidationResult = #{$incomeValidationResult}"
	assert status == :pass
	assert $incomeValidationResult == "SUFFICIENT"
  end
  
  def test_rules_212
    rules  = Rools::RuleSet.new 'test/data/rules212.csv'
	status = rules.assert @customer1, @loan1
	#puts "$debtResearchResult = #{$debtResearchResult}"
	assert status == :pass
	assert $debtResearchResult == "Low"
  end
  
  def test_rules_301
    rules  = Rools::RuleSet.new 'test/data/rules301.csv'
	status = rules.assert @customer1
	#puts "$summary = #{$summary}"
	assert status == :pass
	assert $summary == "The borrower has been successfully pre-qualified for the requested loan. Congratulations!"
  end
  
  def test_customer_2
    rules  = Rools::RuleSet.new 'test/data/rules101.csv'
	status = rules.assert @customer2, @loan2
  	#puts "$incomeValidationResult = #{$incomeValidationResult}"
	assert status == :pass
	assert $incomeValidationResult == "SUFFICIENT"
	
	rules.load_csv( 'test/data/rules212.csv' )
	status = rules.evaluate
	#puts "$debtResearchResult = #{$debtResearchResult}"
	assert status == :pass
	assert $debtResearchResult == "Low"

    rules.load_csv('test/data/rules301.csv')	
    status = rules.evaluate
	#puts "$summary = #{$summary}"
	assert status == :pass
	assert $summary == "The borrower has been successfully pre-qualified for the requested loan. Congratulations!"
    
  end
end