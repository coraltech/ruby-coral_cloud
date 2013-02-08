# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "coral_cloud"
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adrian Webb"]
  s.date = "2013-02-08"
  s.description = "= coral_cloud\n\nThis library provides the ability to define and manage servers.  These servers \ncan be local virtual machines (interfaced by Vagrant) or (in the near future)\nremote servers on various IAAS providers, such as Rackspace and Amazon.\n\nThis library utilizes the Puppet provisioner to build servers and Vagrant\nto run them locally.  Eventually a cohesive API will be developed that will\nallow for easily switching and performing the same operations on different\nproviders.  For now this library focuses on integration with Vagrant.\n\nMore to come soon...\n       \nNote:  This library is still very early in development!\n\n== Contributing to coral_cloud\n \n* Check out the latest master to make sure the feature hasn't been implemented \n  or the bug hasn't been fixed yet.\n* Check out the issue tracker to make sure someone already hasn't requested \n  it and/or contributed it.\n* Fork the project.\n* Start a feature/bugfix branch.\n* Commit and push until you are happy with your contribution.\n* Make sure to add tests for it. This is important so I don't break it in a \n  future version unintentionally.\n* Please try not to mess with the Rakefile, version, or history. If you want \n  to have your own version, or is otherwise necessary, that is fine, but \n  please isolate to its own commit so I can cherry-pick around it.\n\n== Copyright\n\nLicensed under GPLv3.  See LICENSE.txt for further details.\n\nCopyright (c) 2013  Adrian Webb <adrian.webb@coraltech.net>\nCoral Technology Group LLC"
  s.email = "adrian.webb@coraltech.net"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "coral_cloud.gemspec",
    "lib/coral_cloud.rb",
    "lib/coral_cloud/base.rb",
    "lib/coral_cloud/event/puppet_event.rb",
    "lib/coral_cloud/server.rb",
    "lib/coral_cloud/share.rb",
    "spec/coral_test_kernel.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/coraltech/ruby-coral_cloud"
  s.licenses = ["GPLv3"]
  s.rdoc_options = ["--title", "Coral Cloud library", "--main", "README.rdoc", "--line-numbers"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.1")
  s.rubyforge_project = "coral_cloud"
  s.rubygems_version = "1.8.15"
  s.summary = "Provides the ability to define and manage clouds of local and remote servers"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<coral_core>, ["~> 0.1"])
      s.add_development_dependency(%q<bundler>, ["~> 1.2"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8"])
      s.add_development_dependency(%q<rspec>, ["~> 2.10"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
    else
      s.add_dependency(%q<coral_core>, ["~> 0.1"])
      s.add_dependency(%q<bundler>, ["~> 1.2"])
      s.add_dependency(%q<jeweler>, ["~> 1.8"])
      s.add_dependency(%q<rspec>, ["~> 2.10"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
    end
  else
    s.add_dependency(%q<coral_core>, ["~> 0.1"])
    s.add_dependency(%q<bundler>, ["~> 1.2"])
    s.add_dependency(%q<jeweler>, ["~> 1.8"])
    s.add_dependency(%q<rspec>, ["~> 2.10"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
  end
end

