require 'rools/errors'
require 'rools/rule'
require 'rools/base'

module Rools
  class RuleSet < Base
  
    PASS = :pass
    FAIL = :fail
    
  
    # You can pass a set of Rools::Rules with a block parameter,
    # or you can pass a file-path to evaluate.
    def initialize(file = nil, &b)
      
      @rules = {}
      @dependencies = {}
      
      if block_given?
        instance_eval(&b)
      else
        instance_eval(File::open(file).read)
      end
    end		
    
    # rule creates a Rools::Rule. Make sure to use a descriptive name or symbol.
    # For the purposes of extending Rules, all names are converted to
    # strings and downcased.
    # ==Example
    #   rule 'ruby is the best' do
    #     condition { language.name.downcase == 'ruby' }
    #     consequence { "#{language.name} is the best!" }
    #   end
    def rule(name, &b)
      name.to_s.downcase!
      @rules[name] = Rule.new(self, name, b)
    end
    
    # Use in conjunction with Rools::RuleSet#with to create a Rools::Rule dependent on
    # another. Dependencies are created through names (converted to
    # strings and downcased), so lax naming can get you into trouble with
    # creating dependencies or overwriting rules you didn't mean to.
    def extend(name, &b)
      name.to_s.downcase!
      @extend_rule_name = name
      instance_eval(&b) if block_given?
      return self
    end
    
    # Used in conjunction with Rools::RuleSet#extend to create a dependent Rools::Rule
    # ==Example
    #   extend('ruby is the best').with('ruby rules the world') do
    #     condition { language.age > 15 }
    #     consequence { "In the year 2008 Ruby conquered the known universe" }
    #   end
    def with(name, &b)
      name.to_s.downcase!
       (@dependencies[@extend_rule_name] ||= []) << Rule.new(self, name, b)
    end
    
    # Stops the current assertion. Does not indicate failure.
    def stop(message = nil)
      @assert = false
    end
    
    # Stops the current assertion and change status to :fail
    def fail(message = nil)
      @status = FAIL
      @assert = false
    end
    
    # Used to create a working-set of rules for an object, and evaluate it
    # against them. Returns a status, simply PASS or FAIL
    def assert(obj)
      @status = PASS
      @assert = true
      
      # create a working-set of all parameter-matching, non-dependent rules
      available_rules = @rules.values.select { |rule| rule.parameters_match?(obj) }
      
      begin
        
        # loop through the available_rules, evaluating each one,
        # until there are no more matching rules available
        begin # loop
          
          # the loop condition is reset to break by default after every iteration
          matches = false
          logger.debug("available rules: #{available_rules.size.to_s}") if logger
          available_rules.each do |rule|
            # RuleCheckErrors are caught and swallowed and the rule that
            # raised the error is removed from the working-set.
            begin
              if rule.conditions_match?(obj)
                logger.debug("rule #{rule} matched") if logger
                matches = true
                
                # remove the rule from the working-set so it's not re-evaluated
                available_rules.delete(rule)
                
                # find all parameter-matching dependencies of this rule and
                # add them to the working-set.
                if @dependencies.has_key?(rule.name)
                  available_rules += @dependencies[rule.name].select do |dependency|
                    dependency.parameters_match?(obj)
                  end
                end
                
                # execute this rule
                logger.debug("executing rule #{rule}") if logger
                rule.call(obj)
                
                # break the current iteration and start back from the first rule defined.
                break
              end # if rule.conditions_match?(obj)
              
            rescue RuleCheckError => e
              # log da error or sumpin
              available_rules.delete(e.rule)
              @status = fail
            end # begin/rescue
            
          end # available_rules.each
          
        end while(matches && @assert)
        
      rescue RuleConsequenceError => rce
        # RuleConsequenceErrors are allowed to break out of the current assertion,
        # then the inner error is bubbled-up to the asserting code.
        @status = fail
        raise rce.inner_error
      end
      
      @assert = false
      
      return @status
    end # def assert
    
  end # class RuleSet
end # module Rools