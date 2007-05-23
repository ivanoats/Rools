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

 class NewEmployee
    attr_accessor :name, :occupation
      def initialize( name, occupation)
        @name = name
        @occupation = occupation
      end
      def to_s
        return name
      end
    end
    
class RulesTest < Test::Unit::TestCase
  def setup
    #Rools::Base.logger = Logger.new(STDOUT)
  end
  
  def test_hello
    rules = Rools::RuleSet.new do
		rule 'Hello' do
			parameter String
			consequence { puts "Hello, Rools!" }
		end
	end
	
	status = rules.assert 'Heya'
	#puts "executed: #{rules.num_executed}"
	assert status == :pass
	assert rules.num_executed == 1
	assert rules.num_evaluated == 1
  end
  
  def test_file
	rules  = Rools::RuleSet.new 'test/data/hello.rb'
	status = rules.assert 'Heya'
	assert status == :pass
	assert rules.num_executed == 1
	assert rules.num_evaluated == 1
  end
  
  def test_object
    rules = Rools::RuleSet.new do
      rule 'Programmer' do
   	    parameter NewEmployee
     	condition { newemployee.occupation == 'coder' }
    	consequence { puts "#{newemployee} is a coder" }
      end

      rule 'Manager' do
	    parameter NewEmployee
   		condition { newemployee.occupation == 'manager' }
   		consequence { puts "#{newemployee} is a manager" }
      end
    end
    jd = NewEmployee.new('John Doe', 'coder')
    status = rules.assert( jd )
	assert status == :pass
	assert rules.num_executed == 1
	assert rules.num_evaluated == 2
	
  end
end