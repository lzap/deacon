require File.expand_path('../lib/deacon/version.rb', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'deacon'
  s.version     = Deacon::VERSION
  s.licenses    = ['GPLv3', 'Public domain']
  s.date        = Date.today.to_s
  s.authors     = ['Lukas Zapletal']
  s.email       = ['lukas-x@zapletalovi.com']
  s.homepage    = 'https://github.com/lzap/deacon'
  s.summary     = 'Human readable random name generator'
  s.description = 'Provides human readable name using continious LFSR'

  s.files = Dir['lib/**/*', 'data/*.txt', 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_development_dependency 'rdoc'
end
