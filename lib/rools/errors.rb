module Rools

  class RuleError < StandardError
      attr_reader :rule, :inner_error
      
      # Pass the Rools::Rule that caused the error, and an optional inner_error
      def initialize(rule, inner_error = nil)    
        @rule = rule
        @inner_error = inner_error      
      end
      
      # returns the name of the associated Rools::Rule, and the message of the inner_error
      def to_s
        "#{@rule.name}\n#{@inner_error.to_s}"
      end
      
  end
  
  # See: Rools::RuleError (RuleCheckError is only a default derivation)
  class RuleCheckError < RuleError
  end

  # See: Rools::RuleError (RuleConsequenceError is only a default derivation)
  class RuleConsequenceError < RuleError
  end
  
  # See: Rools::RuleError (RuleLoadingError is only a default derivation)
  class RuleLoadingError < StandardError
  end
  
end