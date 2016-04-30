# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ircblowfish/version'

Gem::Specification.new do |spec|
  spec.name          = "ircblowfish"
  spec.version       = IrcBlowfish::VERSION
  spec.authors       = ["Jason Iverson"]
  spec.email         = ["iverson.jason.code@gmail.com"]

  spec.summary       = %q{Encryption Module for IRC Blowfish}
  spec.description   = %q{A Ruby module for encrypting and decrypting IRC Blowfish ECB/CBC messages}
  spec.homepage      = "https://github.com/JasonIverson/ircblowfish/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
