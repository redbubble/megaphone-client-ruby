# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'megaphone/client/version'

Gem::Specification.new do |spec|
  spec.name          = "megaphone-client"
  spec.version       = Megaphone::Client::VERSION
  spec.authors       = ["Redbubble", "Gonzalo Bulnes Guilpain", "Guilherme Reis Campos"]
  spec.email         = ["developers@redbubble.com", "gonzalo.bulnes@redbubble.com", "guilherme.campos@redbubble.com"]

  spec.summary       = "Send events to Megaphone."
  spec.homepage      = "https://github.com/redbubble/megaphone-client-ruby"
  spec.license       = "GPL-3.0"

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib"]

  spec.add_dependency "fluent-logger", "~> 0.7.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
