require 'rools/errors'
require 'rools/default_parameter_proc'
require 'rools/rule_set'
require 'rools/rule'

# All classes are contained in the Rools module
module Rools
  
  @@rule_sets = {}
  
  # open aliases Rools::RuleSet.new, and caches RuleSets loaded by path
  def self.open(path = nil, &b)
    path.nil? ? Rools::RuleSet.new(path, &b) : (@@rule_sets[path] ||= Rools::RuleSet.new(path))
  end
end