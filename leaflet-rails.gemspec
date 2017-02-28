# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "leaflet-rails/version"

Gem::Specification.new do |s|
  s.name        = "leaflet-rails"
  s.version     = Leaflet::Rails::VERSION
  s.authors     = ["Akshay Joshi"]
  s.email       = ["joshi.a@gmail.com"]
  s.license     = "BSD"
  s.homepage    = ""
  s.summary     = %q{Use leaflet.js with Rails 4/5.}
  s.description = %q{This gem provides the leaflet.js map display library for your Rails 4/5 application.}

  s.rubyforge_project = "leaflet-rails"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rails", '>= 4.2.0'
  s.add_development_dependency "rspec", '<= 3.4.0'
  s.add_development_dependency "simplecov-rcov"
end
