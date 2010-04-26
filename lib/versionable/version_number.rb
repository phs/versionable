module Versionable
  # A String containing a dotted sequence of positive integers.
  class VersionNumber < String
    VERSION_NUMBER_REGEX = /^(?:0|[1-9]\d*)(?:\.(?:0|[1-9]\d*))*$/

    # Construct a VersionNumber from something that responds to <tt>#to_s</tt>.
    #
    # If the to_s'd argument does not match VERSION_NUMBER_REGEX, an ArgumentError is raised.
    def initialize(v)
      v = v.to_s
      unless v =~ VERSION_NUMBER_REGEX
        raise ArgumentError.new "#{v.inspect} is not a dotted sequence of positive integers"
      end
      super v
    end

    # Compare version numbers as lists of integers.
    #
    # If one version number has more segments than the other, the shorter one is right-extended
    # with zeros.
    #
    # For example, when comparing 0.2 to 0.10.1, the 0.2 is extended to 0.2.0.  The left two 0s
    # are equal, so comparison shifts to 2 and 10: 0.10.1 is the greater version.
    def <=>(other)
      my_segments, their_segments = to_s.split('.'), other.to_s.split('.')
      size_difference = my_segments.size - their_segments.size

      if size_difference > 0
        their_segments.concat(['0'] * size_difference)
      elsif size_difference < 0
        my_segments.concat(['0'] * -size_difference)
      end

      partwise = my_segments.zip(their_segments).collect do |mine, theirs|
        mine.to_i <=> theirs.to_i
      end

      partwise.detect { |cmp| cmp != 0 } || 0
    end

    # Test equality based on the <=> operator.
    #
    # Particularly, 2 == 2.0 == 2.0.0.0
    def ==(other)
      (self <=> other) == 0
    end

    # Hash the version number string after stripping any trailing zeroes.
    #
    # This preserves the hash/equality contract: 2 == 2.0, so they both hash the same as well.
    def hash
      sub(/(\.0)+$/, '').to_s.hash
    end
  end
end