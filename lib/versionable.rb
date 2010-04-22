module Versionable
  # A StandardError representing an error when creating versions.
  class VersioningError < StandardError
  end
end

require 'versionable/version_number'
require 'versionable/versions'

# A Mixin enabling versioning of the mixer.  See ClassMethods.
module Versionable

  def self.included(base)
    base.extend ClassMethods
  end

  # Provides methods for creating and accessing versions of the class or module.
  module ClassMethods

    # Build a new version of the class or module.
    # 
    # See Versions#build.
    def version(version_number, &block)
      versions.build(version_number, &block)
    end

    # Find a version by number or with a requirement, such as with VersionedClass["< 3.0"].
    # 
    # See Versions#find.
    def [](version_requirement)
      versions.find(version_requirement)
    end

    # Get the Versions collection on this class or module.
    def versions
      @versions ||= Versions.new(self)
    end

  end

end
