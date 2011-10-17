module Rools
 class Base
    @@logger = nil
    
    def logger
      return @@logger
    end
    
    def self.logger= (newlogger)
      @@logger = newlogger
    end
  end
end