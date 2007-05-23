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
  
  def test_miss_symbol
   
      ruleset = Rools::RuleSet.new do
		rule 'Hello' do
		    parameter String
			consequence { puts "Hello, Rools! #{str}" }
		end
	  end
	  
	  status = ruleset.assert "heya"
	  assert status == Rools::RuleSet::FAIL
  end

end
