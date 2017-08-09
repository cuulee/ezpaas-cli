# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ezpaas/cli/version'

Gem::Specification.new do |spec|
  spec.name          = 'ezpaas-cli'
  spec.version       = EzPaaS::CLI::VERSION
  spec.authors       = ['Nick Lee']
  spec.email         = ['nick@tendigi.com']

  spec.summary       = 'A gem';
  spec.description   = 'Lol';
  spec.homepage      = 'TODO: Put your gem\'s website or public repo URL here.'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # spec.files         = `git ls-files -z`.split('\x0').reject do |f|
  #   f.match(%r{^(test|spec|features)/})
  # end

  spec.files = %x{ git ls-files }.split("\n").select { |d| d =~ %r{^(LICENSE|README|bin/|data/|ext/|lib/|spec/|test/)} }
  
  # spec.bindir        = 'exe'

  spec.executables   = ['ezpaas']  
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '~> 0.19.4'
  spec.add_dependency 'tty', '~> 0.7.0'
  spec.add_dependency 'httparty', '~> 0.15.6'
  spec.add_dependency 'random-word', '~> 2.0.0'
  spec.add_dependency 'git', '~> 1.3.0'
  spec.add_dependency 'excon', '~> 0.58.0'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  
end
