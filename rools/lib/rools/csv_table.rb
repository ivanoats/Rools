#require 'rubygems'
#require_gem 'fastercsv'
require 'csv'
require 'rools/base'

module Rools
  
  class CsvTable < Base
    attr_reader :rules
  
    #
    # return quoted String or Number
    # There is probably a more elagant way of doing this but...
    # 
    def quote( str )
      return str if (str.to_i.to_s == str)
      return str if (str.to_f.to_s == str)
      '"' + str + '"'
    end
    
    def initialize( fileName )
      csv_data = IO.read( fileName)
      arrs = []
      CSV::Reader.parse(csv_data, ",", "\r") do |row|
        #puts "row:#{row.inspect}"
        arrs << row
      end
      
      # get rule parameter 
      parameter = arrs[1][1]
      #puts "parameter:#{parameter}"
      
      # get rule elements Conditions/Consequences
      rule_elements = arrs[2]
      
      # get code
      rule_code = arrs[3]      
      
      # get headers
      headers = arrs[4]
      
      #get number of rules
      num_rules = arrs.size-5
      #puts "num rules: #{num_rules}"
      
      index   = 0
      @rules  = ""
      arrs[5..arrs.size].each { |arr|
        rule_name = "rule_#{index}"
        #puts "arr:#{arr} index: #{index}"
        
        #if rule_elements[index] != nil
          @rules << "rule '#{rule_name}' do \n"
          @rules << "  parameter #{parameter}\n"
          column = 0
          
          rule_elements.each do |element|
            
            field  = headers[column].downcase if headers[column]
            str    = arr[column]
            
            if str != nil && element != nil
              #puts ("eval: #{field} = '#{str}'")
              #eval( "#{field} = '#{str}'" )
  
              @rules << "\t" + element.downcase + "{ "
              pattern = "\#\{#{field}\}"
              
              #puts rule_code[column]
              #puts "pattern: #{pattern} str:#{str}"
              if rule_code[column] == pattern
                statement = str # straight replace
              else
                statement = rule_code[column].gsub(pattern,quote(str))
              end
              
              #puts "statement:#{statement}"
              
              @rules << statement     
              @rules << "}\n"
            end
            
            column += 1
          end
          @rules << "end\n"
        #end
        index += 1
      }
    end
  end
  
 
  
end