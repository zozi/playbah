# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'playbah/version'

Gem::Specification.new do |spec|
  spec.name          = "playbah"
  spec.version       = Playbah::VERSION
  spec.authors       = ["Adam Cooper"]
  spec.email         = ["adam.cooper@gmail.com"]
  spec.description   = %q{Playball with your development env}
  spec.summary       = %q{Send messages and logs to your teammates}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_dependency "hipchat"
  spec.add_dependency "gist"
end
