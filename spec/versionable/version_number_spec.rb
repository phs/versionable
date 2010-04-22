require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Versionable::VersionNumber do
  
  def v(version)
    Versionable::VersionNumber.new(version)
  end
  
  it "is a string" do
    v("1.0").should be_a String
  end
  
  it "rejects versions that aren't dotted sequences of positive integers" do
    lambda { v "dog" }.should raise_error ArgumentError
    lambda { v "-1"  }.should raise_error ArgumentError
  end

  describe "<=>" do
    it "sorts by segments from left to right" do
      v("10.0").should > v("2.0")
      v("10.1").should < v("10.2")
    end
    
    it "right-pads missing segments with zeros" do
      v("1").should == v("1.0")
      v("1.0").should == v("1.0.0.0.0.0.0.0.0")
      v("10").should > v("3.2.1")
    end
  end
  
  describe "#next" do
    it "bumps most significant segment by 1 and drops remainder" do
      v("1.0").next.should == v("2")
    end
  end

  describe "#hash" do
    it "is the string hash after stripping trailing zero segments" do
      v("1").hash.should == v("1.0.000").hash
      v("1").hash.should_not == v("2").hash
    end
  end

end
