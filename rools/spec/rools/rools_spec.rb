require File.dirname(__FILE__) + '/../spec_helper'
require 'rools'

describe "Rools" do

  it "should have a logger" do
   #Rools::Base.logger = Logger.new(STDOUT)
   #Rools::Base.logger.debug( "rools")
   Rools::Base.logger = nil
  end
  
  it "should cache" do
    Rools::open(nil)
  end
end
