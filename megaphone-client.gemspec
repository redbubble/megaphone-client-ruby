# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'megaphone/client/version'

Gem::Specification.new do |spec|
  spec.name          = "megaphone-client"
  spec.version       = Megaphone::Client::VERSION
  spec.authors       = ["Gonzalo Bulnes Guilpain", "Guilherme Reis Campos"]
  spec.email         = ["gonzalo.bulnes@redbubble.com", "guilherme.campos@redbubble.com"]

  spec.summary       = "Send events to Megaphone."
  spec.homepage      = "https://github.com/redbubble/megaphone-client-ruby"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = []
  spec.require_paths = ["lib"]

  spec.add_dependency "fluent-logger", "~> 0.7.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
