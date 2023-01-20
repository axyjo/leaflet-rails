# frozen_string_literal: true

require_relative 'lib/leaflet-rails/version'

Gem::Specification.new do |s|
  s.name        = 'leaflet-rails'
  s.version     = Leaflet::Rails::VERSION
  s.authors     = ['Akshay Joshi']
  s.email       = ['leaflet_rails@akshayjoshi.com']
  s.license     = 'BSD'
  s.homepage    = ''
  s.summary     = 'Use leaflet.js with Rails 4/5.'
  s.description = 'This gem provides the leaflet.js map display library for your Rails 4+ application.'

  s.files         = Dir['lib/**/*', 'vendor/**/*']
  s.test_files    = Dir['spec/**/*']
  s.executables   = []
  s.require_paths = ['lib']

  s.add_dependency 'railties', '>= 4.2.0'
  s.add_dependency 'actionpack', '>= 4.2.0'
  s.add_development_dependency 'rspec', '<= 3.4.0'
  s.add_development_dependency 'simplecov-rcov'
end
