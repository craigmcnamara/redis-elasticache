# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis/elasticache/version'

Gem::Specification.new do |spec|
  spec.name          = "redis-elasticache"
  spec.version       = Redis::Elasticache::VERSION
  spec.authors       = ["Craig McNamara", "Eddy Kim"]
  spec.email         = ["craig@caring.com", "eddy.kim@dollarshaveclub.com"]

  spec.summary       = %q{Adds missing support for AWS Elasticache to the redis-rb gem.}
  spec.description   = %q{Enable applications to handle AWS Elasticache cluster failovers without rebooting the app.}
  spec.homepage      = "https://github.com/craigmcnamara/redis-elasticache"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "redis", ">= 3.0.0", "<= 4.0.1"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
