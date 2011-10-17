require 'rubygems'
require 'rools'

  rules = Rools::RuleSet.new do
	rule 'Hello' do
	   parameter String
	   consequence { puts "Hello, Rools!" }
	end
  end
  
  rules.assert 'Heya'