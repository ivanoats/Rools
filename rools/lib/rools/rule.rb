require 'rools/errors'
require 'rools/default_parameter_proc'

module Rools
  class Rule
    attr_reader :name
    
    # A Rule requires a Rools::RuleSet, a name, and an associated block
    # which will be executed at initialization
    def initialize(rule_set, name, b)
      @rule_set = rule_set
      @name = name
      
      @conditions = []
      @consequences = []
      @parameters = []
      
      instance_eval(&b)
    end
    
    # Adds a condition to the Rule.
    # For readability, it might be preferrable to use a
    # new condition for every evaluation when possible.
    # ==Example
    #   condition { person.name == 'Fred' }
    #   condition { person.age > 18 }
    # As opposed to:
    #   condition { person.name == 'Fred' && person.age > 18 }
    def condition(&b)
      @conditions << DefaultParameterProc.new(self, b)
    end
    
    # Adds a consequence to the Rule
    # ==Example
    #   consequence { user.failed_logins += 1; user.save! }
    def consequence(&b)
      @consequences << DefaultParameterProc.new(self, b)
    end
    
    # Sets the parameters of the Rule
    # ==Example
    #   parameters Person, :name, :occupation
    # The arguments passed are evaluated with :is_a? for each
    # constant-name passed, and :responds_to? for each symbol.
    # So the above example would be the same as:
    #   obj.is_a?(Person) &&
    #     obj.responds_to?(:name) &&
    #     obj.responds_to?(:occupation)
    # You can pass any combination of symbols or constants.
    # You might want to refrain from referencing constants to
    # aid in "duck-typing", or you might want to use parameters such as:
    #   parameters Person, Employee, :department
    # To verify that the asserted object is an Employee, that inherits from
    # Person, and responds to :department
    def parameters(*matches)
      @parameters += matches
    end
    
    # parameters is aliased to aid in readability if you decide
    # to pass only one parameter.
    alias :parameter :parameters
    
    # Checks to see if this Rule's parameters match the asserted object
    def parameters_match?(obj)
      @parameters.each do |p|
        if p.is_a?(Symbol)
          return false unless obj.respond_to?(p)
        else
          return false unless obj.is_a?(p)
        end
      end
      
      return true
    end
    
    # Checks to see if this Rule's conditions match the asserted object
    # Any StandardErrors are caught and wrapped in RuleCheckErrors, then raised.
    def conditions_match?(obj)
      begin
        @conditions.each { |c| return false unless c.call(obj) }
      rescue StandardError => e
        raise RuleCheckError.new(self, e)
      end
      
      return true
    end
    
    # Calls Rools::RuleSet#assert in the bound working-set
    def assert(obj)
      @rule_set.assert(obj)
    end
    
    # Execute each consequence.
    # Any StandardErrors are caught and wrapped in Rools::RuleConsequenceError,
    # then raised to break out of the current assertion.
    def call(obj)
      begin
        @consequences.each do |c|
          c.call(obj)
        end
      rescue StandardError => e
        # discontinue the Rools::RuleSet#assert if any consequence fails
        raise RuleConsequenceError.new(rule, e)
      end
    end
    
    # Stops the current assertion. Does not indicate failure.
    def stop(message = nil)
      @rule_set.stop(message)
    end
    
    # Stops the current assertion and change status to :fail
    def fail(message = nil)
      @rule_set.fail(message)
    end
  end
end