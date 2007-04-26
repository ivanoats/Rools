require 'rools/errors'
require 'rools/default_parameter_proc'
require 'rools/base'

module Rools
  class Facts < Base
    attr_reader :name, :fact_value
    
    def initialize(rule_set, name, b)
      @name = name
      @fact_value = instance_eval( &b )
      logger.debug "New Facts: #{@fact_value}" if logger
    end
  end
end