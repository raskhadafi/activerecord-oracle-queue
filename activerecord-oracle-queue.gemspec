# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "activerecord/oracle/queue/version"

Gem::Specification.new do |spec|
  spec.name          = "activerecord-oracle-queue"
  spec.version       = Activerecord::Oracle::Queue::VERSION
  spec.authors       = ["Roman Simecek"]
  spec.email         = ["roman.v.simecek@gmail.com"]

  spec.summary       = %q{Extension of ActiveRecord for ORACLE queues}
  spec.description   = %q{This gem extends active record and it's migrations for oracle queue support.}
  spec.homepage      = "http://good2go.ch"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "railties"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "terminal-notifier-guard"
  spec.add_development_dependency "simplecov"

  spec.add_development_dependency "yard"
  spec.metadata["yard.run"] = "yri"
end
