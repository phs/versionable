# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{versionable}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Phil Smith"]
  s.date = %q{2010-04-26}
  s.description = %q{Versionable lets a ruby module or class declare multiple numbered versions of itself, and provides a way to select one based on a gem-like requirement.}
  s.email = %q{phil.h.smith@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/versionable.rb",
     "lib/versionable/version_number.rb",
     "lib/versionable/versions.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/versionable/version_number_spec.rb",
     "spec/versionable_spec.rb",
     "versionable.gemspec"
  ]
  s.homepage = %q{http://github.com/phs/versionable}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{An api for versioning ruby modules}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/versionable/version_number_spec.rb",
     "spec/versionable_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end

