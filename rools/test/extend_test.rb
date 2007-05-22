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
require 'date'

class User
  attr_reader   :login, :valid, :password, :last_logon
  attr_accessor :admin, :customer
  
  def initialize( login, password)
    @login    = login
    @password = password
    @admin    = false
    @last_login = Date.today
  end
  
  def admin?
    return @admin
  end
  
  def customer?
    return @customer
  end
  
  def valid?
    return true
  end
  
  def to_s
    return @login
  end
end

class ExtendTest < Test::Unit::TestCase

  def setup
    #Rools::Base.logger = Logger.new(STDOUT)
  end

  def test_extend_1
    ruleset = Rools::RuleSet.new do
      rule 'one' do
        parameter Fixnum
        condition {fixnum > 100}
        consequence { $result = "higher" }
      end

      extend('one').with('two') do
        condition {fixnum < 1000}
        consequence do
          $result = "within"
        end
      end
    end
    
    # dependant rule will not be evaluated
    status = ruleset.assert 20
    assert ruleset.num_evaluated == 1 
    assert ruleset.num_executed == 0
  end
  
   def test_extend_2
    ruleset = Rools::RuleSet.new do
      rule 'one' do
        parameter Fixnum
        condition {fixnum > 100}
        consequence {$result = "higher"}
      end

      extend('one').with('two') do
        condition {fixnum < 1000}
        consequence do
          $result = "within"
        end
      end
    end
    
    #dependant rule will also be evaluated and executed
    #after rule1
    status = ruleset.assert 200
    assert ruleset.num_evaluated == 2 
    assert ruleset.num_executed == 2
  end
  
  def test_extend_user
    ruleset = Rools::RuleSet.new do
        rule 'Valid User' do
          parameter User
          condition { user.valid? }
          condition { user.password.size > 6 }
          consequence { $result = "#{user} is valid" }
        end
        
        extend('Valid User') do
                with 'Administrative User' do
                        condition { user.admin? }
                        consequence { $result = "#{user} is an admin" }
                end

                with 'Customer User' do
                        condition { user.customer? }
                        consequence { $result = "#{user} is a customer" }
                end
        end
        
    end
    user1 = User.new( "pat", "password")
    status = ruleset.assert user1
    assert ruleset.num_evaluated == 3
    assert ruleset.num_executed == 1
    
    user1.admin = true
    ruleset.delete_facts
    status = ruleset.assert user1
    assert ruleset.num_evaluated == 3
    assert ruleset.num_executed == 2
    
  end
  
end
