module Versionable
  class Versions
    
    def initialize(versioned_class)
      @latest_version = versioned_class
    end
    
    def build(version_number, block)
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
      
      latest_version.module_eval &block if block

      self.latest_version_number = version_number
    end
    
    def find(version_requirement)
      if version_requirement =~ VersionNumber::REGEX
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

    COMPARISON_REGEX = /^(<|<=|=|>=|>)\s+(\d+(?:\.\d+)*)$/

    attr_accessor :latest_version
    attr_accessor :default_version
    attr_writer :latest_version_number

    def latest_version_number
      @latest_version_number ||= VersionNumber.new("0")
    end

    def default_version_is_open?
    end

    def versions
      @versions ||= Hash.new do |hash, key|
        latest_version_number == key ? latest_version : nil
      end
    end
  end
end
