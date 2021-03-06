# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mcarg/version'

Gem::Specification.new do |spec|
  spec.name          = "mcarg"
  spec.version       = MCArg::VERSION
  spec.authors       = ["Emmanuel Hadoux"]
  spec.email         = ["emmanuel.hadoux@gmail.com"]

  spec.summary       = %q{MCArg}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/EHadoux/mcarg"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "commander"
  spec.add_dependency "ruby-graphviz"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "solid_assert"
  spec.add_development_dependency "ruby-prof"
end
