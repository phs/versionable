module Versionable  
  class VersioningError < StandardError
  end 
end

require 'versionable/version_number'
require 'versionable/versions'

module Versionable  

  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods

    def version(version_number, &block)
      versions.build(version_number, block)
    end

    def [](version_requirement)
      versions.find(version_requirement)
    end

    def versions
      @versions ||= Versions.new(self)
    end

  end  

end
