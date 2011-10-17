require 'test/unit'
require 'rools'
require 'rools/base'
require 'logger'

module Ptest
  class TestClass
    attr_accessor :value
    
    def initialize( value )
      @value = value
    end
    
    def to_s
      @value
    end
    
    def method_missing(sym, *args)
      return
    end
    
  end
end

class TestClass2
    attr_accessor :value
    
    def initialize( value )
      @value = value
    end
    
    def to_s
      @value
    end
  end
  
class NamespaceTest < Test::Unit::TestCase

  def setup
    Rools::Base.logger = Logger.new(STDOUT)
  end
  
  def test_namespace
    rs = Rools::RuleSet.new do
      rule 'one' do
        condition{true}
        consequence {$result = ptest__testclass.value}
      end
    end

    rs.assert(Ptest::TestClass.new(12))
    assert $result == 12
  
  end
end
