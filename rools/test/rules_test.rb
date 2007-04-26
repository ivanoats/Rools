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

 class Person
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
	assert status == :pass
  end
  
  def test_object
    rules = Rools::RuleSet.new do
      rule 'Programmer' do
   	    parameter Person
     	condition { person.occupation == 'coder' }
    	consequence { puts "#{person} is a coder" }
      end

      rule 'Manager' do
	    parameter Person
   		condition { person.occupation == 'manager' }
   		consequence { puts "#{person} is a manager" }
      end
    end
    jd = Person.new('John Doe', 'coder')
    status = rules.assert( jd )
	assert status == :pass
  end
end