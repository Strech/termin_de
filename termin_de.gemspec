# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'termin_de/version'

Gem::Specification.new do |spec|
  spec.name          = "termin_de"
  spec.version       = TerminDe::VERSION
  spec.authors       = ["Strech (Sergey Fedorov)"]
  spec.email         = ["oni.strech@gmail.com"]

  spec.summary       = "Simple termin monitor"
  spec.description   = "Monitoring termin cancelation for Burgeramt"
  spec.homepage      = "https://github.com/Strech/termin_de"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "curb", ">= 0.8.8"
  spec.add_dependency "nokogiri", ">= 1.6.6"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  # TODO : TDD ...
  #spec.add_development_dependency "rspec"
end
