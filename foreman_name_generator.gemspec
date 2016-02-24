require File.expand_path('../lib/foreman_name_generator/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_name_generator'
  s.version     = ForemanNameGenerator::VERSION
  s.licenses    = ['GPLv3', 'Public domain']
  s.date        = Date.today.to_s
  s.authors     = ['Lukas Zapletal']
  s.email       = ['lukas-x@zapletalovi.com']
  s.homepage    = 'http://github.com/lzap/foreman-name-generator'
  s.summary     = 'Human readable names for Foreman hosts'
  s.description = 'Provides human readable names for Foreman hosts and other entities'

  s.files = Dir['{app,config,lib,locale}/**/*', 'data/*.txt'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
