module Versionable
  # A container for all versions of a given module.
  class Versions
    COMPARISON_REGEX = /^(<|<=|=|>=|>)\s+((?:0|[1-9]\d*)(?:\.(?:0|[1-9]\d*))*)$/
    
    # Construct a Versions recording versions of the passed module.
    def initialize(versioned_module)
      @latest_version = versioned_module
    end
    
    # Build and store a new version with the given number.
    # 
    # Versions must be built in increasing order: if version_number is not greater than the previous version, an ArgumentError is raised.
    # The initial version number is always 0.
    # 
    # If a block parameter is passed, it is included in the created version.
    # If this is the first time a block is passed, then record the _previous_ version as the default one.
    # Once build is called with a block, subsequent versions must also pass a block or a VersioningError will be raised.
    def build(version_number, &block)
      version_number = VersionNumber.new(version_number)

      raise ArgumentError.new "Can't bump to #{version_number} from #{latest_version_number}" unless latest_version_number < version_number
      raise VersioningError.new "Once called with a block, all subsequent versions must pass a block." if default_version and not block

      if block and default_version.nil?
        self.default_version = latest_version
        self.latest_version = latest_version.dup

        versions[latest_version_number] = default_version
      else
        versions[latest_version_number] = latest_version.dup
      end
      
      self.latest_version_number = version_number
      latest_version.module_eval &block if block
    end
    
    # Find the maximal version satisifying the given requirement.
    # 
    # The requirement may be a version string such as "1.0.7", or a comparator followed by a version such as "< 3.0".
    # 
    # Returns the matching module if found, nil otherwise.
    def find(version_requirement)
      if version_requirement =~ VersionNumber::VERSION_NUMBER_REGEX
        versions[VersionNumber.new(version_requirement)]
      elsif version_requirement =~ Versions::COMPARISON_REGEX
        comparator, version_requirement = $1, VersionNumber.new($2)
        comparator = '==' if comparator == '=' # stick that in your pipe and smoke it.
        comparator = comparator.to_sym
        
        match = (versions.keys + [latest_version_number]).select { |v| v.send comparator, version_requirement }.max

        versions[match]
      else
        nil
      end
    end
    
  private

    attr_accessor :latest_version       # :nodoc:
    attr_accessor :default_version      # :nodoc:
    attr_writer :latest_version_number  # :nodoc:

    def latest_version_number
      @latest_version_number ||= VersionNumber.new("0")
    end

    def versions
      @versions ||= Hash.new do |hash, key|
        latest_version_number == key ? latest_version : nil
      end
    end
  end
end
