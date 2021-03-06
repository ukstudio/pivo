# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pivo/version'

Gem::Specification.new do |spec|
  spec.name          = "pivo"
  spec.version       = Pivo::VERSION
  spec.authors       = ["AKAMATSU Yuki"]
  spec.email         = ["y.akamatsu@ukstudio.jp"]
  spec.summary       = %q{for pivotal tracker}
  spec.description   = %q{for pivotal tracker}
  spec.homepage      = "https://github.com/ukstudio/pivo"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "tracker_api", '>=0.2.9'
  spec.add_dependency "thor"
  spec.add_dependency "kosi"
end
