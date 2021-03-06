# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'codex/version'

Gem::Specification.new do |spec|
  spec.name          = "codex"
  spec.version       = Codex::VERSION
  spec.authors       = ["PJK"]
  spec.email         = ["me@pavelkalvoda.com"]
  spec.description   = %q{CodEx code examination system interaction utility}
  spec.summary       = %q{CodEx code examination system interaction utilit}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.bindir        = "bin"
  spec.executables   = ["codex"]

  spec.add_dependency "trollop"
  spec.add_dependency "mechanize"
  spec.add_dependency "highline"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"

end
