module Versionable
  class VersionNumber < String
    REGEX = /^\d+(?:\.\d+)*$/
    
    def initialize(v)
      v = v.to_s
      raise ArgumentError.new "#{v.inspect} is not a dotted sequence of positive integers" unless v =~ REGEX
      super v
    end

    def <=>(other)
      my_segments, their_segments = to_s.split('.'), other.to_s.split('.')
      size_difference = my_segments.size - their_segments.size

      if size_difference > 0
        their_segments.concat(['0'] * size_difference)
      elsif size_difference < 0
        my_segments.concat(['0'] * -size_difference)
      end

      partwise = my_segments.zip(their_segments).collect { |mine, theirs| mine.to_i <=> theirs.to_i }
      partwise.detect { |cmp| cmp != 0 } || 0
    end

    def ==(other)
      (self <=> other) == 0
    end
    
    def next
      self.class.new(split('.', 2).first.to_i + 1)
    end
    
    def hash
      sub(/(\.0+)+$/, '').to_s.hash
    end
  end
end