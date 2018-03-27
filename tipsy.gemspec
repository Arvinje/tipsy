# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tipsy/version'

Gem::Specification.new do |spec|
  spec.name          = "Tipsy"
  spec.version       = Tipsy::VERSION
  spec.authors       = ["Arvin Jenabi"]
  spec.email         = ["Arvinje@gmail.com"]

  spec.summary       = ""
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "celluloid", "~> 0.17.3"
  spec.add_runtime_dependency "redis-namespace", "~> 1.5.2"
  spec.add_runtime_dependency "redis", "~> 3.3.0"
  spec.add_runtime_dependency "mongoid", "~> 5.1.4" 
  spec.add_runtime_dependency "foursquare2", "~> 2.0.2"
  spec.add_runtime_dependency "textoken", "~> 1.1.1"
  spec.add_runtime_dependency "stanford-core-nlp", "~> 0.5.1"
  spec.add_runtime_dependency "descriptive_statistics", '~> 2.5', '>= 2.5.1'
  spec.add_runtime_dependency "puma"
  spec.add_runtime_dependency "sinatra"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4.0"
  spec.add_development_dependency "pry", "~> 0.10.3"
  spec.add_development_dependency "guard-rspec", "~> 4.6.5"
  spec.add_development_dependency "guard-yard", "~> 2.1.4"
  spec.add_development_dependency "terminal-notifier-guard", "~> 1.7"
  spec.add_development_dependency "dotenv", "~> 2.1.1"
end
