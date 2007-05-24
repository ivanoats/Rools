require 'rools/base'
module Rools
  
  # The DefaultParameterProc binds to a Rule and
  # is allows the block to use method_missing to
  # refer to the asserted object.
  class DefaultParameterProc < Base
    
    # Determines whether a method is vital to the functionality
    # of the class.
    def self.is_vital(method)
      return method =~ /__(.+)__|method_missing|instance_eval/
    end

    # Removes unnecessary methods from the class to minimize
    # name collisions with method_missing.      
    for method in instance_methods
      undef_method(method) unless is_vital(method)
    end
    
    # The "rule" parameter must respond to an :assert method.
    # The "b" parameter is a block that will be rebound to this
    # instance.
    def initialize(rule, b)
      raise ArgumentError.new('The "rule" parameter must respond to an :assert method') unless rule.respond_to?(:assert)
      @rule = rule
      @proc = b
      #@working_object = nil
    end
    
    # Call the bound block and set the working object so that it
    # can be referred to by method_missing
    def call(obj)
      #@working_object = obj
      status = instance_eval(&@proc)
      #@working_object = nil
      return status
    end
    
    # Assert a new object up the composition-chain into the current RuleSet
    def assert(obj)
      @rule.assert(obj)
    end
    
    # Parameterless method calls by the attached block are assumed to
    # be references to the working object
    def method_missing(sym, *args)
      # puts "method missing: #{sym} args:#{args.inspect}"
      # check if it is a fact first
      #begin
        facts = @rule.rule_set.get_facts
        if facts.has_key?( sym.to_s )
          #puts "return fact #{facts[sym.to_s].value}" 
          return facts[sym.to_s].value
        else
          raise Exception, "symbol: #{sym} not found in facts"
        end
      #rescue Exception => e
      #  puts "miss exception #{e} #{e.backtrace.join("\n")}"
      #  return nil
      #end
    end
    
    # Stops the current assertion. Does not indicate failure.
    def stop(message = nil)
      @rule.stop(message)
    end
    
    # Stops the current assertion and change status to :fail
    def fail(message = nil)
      @rule.fail(message)
    end
  end
end