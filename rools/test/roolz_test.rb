require 'test/unit'
require 'rools'
require 'rools/base'
require 'logger'

class RoolzTest < Test::Unit::TestCase
  def setup
    Rools::Base.logger = Logger.new(STDOUT)
  end
  
  def test_roolz
  
    rules = Rools::RuleSet.new do
        rule 'Hello' do
            parameter String
            consequence { puts "Hello, Rools!" }
        end
        rule 'Morning' do
            parameter Integer
            consequence { puts "Morning Rools !" }
        end
    end
    
    puts "1 :"
    rules.assert 'Heya'
    
    rules.delete_facts
    
    puts "2 :"
    rules.assert -12
  end
end
