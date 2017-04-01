# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ircblowfish/version'

Gem::Specification.new do |spec|
  spec.name          = "ircblowfish"
  spec.version       = IrcBlowfish::VERSION
  spec.authors       = ["IceN9ne"]
  spec.email         = ["IceN9ne.code@gmail.com"]

  spec.summary       = %q{Ruby Encryption Module for IRC Blowfish Messages}
  spec.description   = %q{A Ruby module for encrypting and decrypting IRC Blowfish ECB/CBC messages}
  spec.homepage      = "https://github.com/JasonIverson/ircblowfish-ruby/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = `git ls-files -z {test,spec,features}/*`.split("\x0")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # May work on older versions, but this is the oldest I tested
  spec.required_ruby_version = ">= 1.9.3"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.requirements << 'openssl'
end
