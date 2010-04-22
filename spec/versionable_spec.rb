require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Versionable do

  it "does seemingly nothing by default" do
    class Unmolested
      include Versionable
      def foo; :foo; end
    end

    Unmolested.new.foo.should == :foo
  end

  describe ".version" do
    it "takes a version number" do
      class Versioned
        include Versionable

        def foo; :past_foo; end
        def baz; :baz; end

        version "1"

        def foo; :foo; end
        def self.bar; :bar; end
      end
    end
    
    it "rejects bad version numbers" do
      lambda do
        class Versioned
          version "chowder!"
        end
      end.should raise_error ArgumentError
    end

    it "rejects non-increasing version numbers" do
      lambda do
        class Versioned; version "0"; end
      end.should raise_error ArgumentError

      lambda do
        class Versioned; version "1"; end
      end.should raise_error ArgumentError
    end
    
    it "takes a block for versions after the default" do
      class Versioned
        version "2" do
          def foo; :future_foo; end
        end

        version "3" do
          def foo; :far_future_foo; end
        end
      end
    end

    it "rejects blockless calls after block ones" do
      lambda do
        class Versioned; version "4"; end
      end.should raise_error Versionable::VersioningError
    end
  end

  describe "[]" do
    it "sends versions to classes" do
      Unmolested['0'].should be_a Class
    end

    it "sends the default version to itself" do
      Unmolested['0'].should == Unmolested
      Versioned['1'].should == Versioned
    end

    it "sends other versions to similar classes, representing older or newer functionality" do
      Versioned['0'].should_not == Versioned
      Versioned['0'].new.foo.should == :past_foo

      Versioned['1'].bar.should == :bar
      lambda { Versioned['0'].bar }.should raise_error NoMethodError

      Versioned['2'].should_not == Versioned
      Versioned['2'].new.foo.should == :future_foo

      Versioned['3'].new.foo.should == :far_future_foo
    end

    it "takes comparator expressions" do
      Versioned[">= 0"].should == Versioned['3']
      Versioned["<= 2"].should == Versioned['2']
      Versioned["< 2"].should == Versioned['1']
      Versioned["= 0"].should == Versioned['0']
      Versioned["> 0"].should == Versioned['3']
    end
  end
  
end
