# -*- coding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'ixtlan-remote'
  s.version = '0.1.0'

  s.summary = ''
  s.description = 'helper sync data between miniapps or communicate wth realtime rest-services'
  s.homepage = 'https://github.com/mkristian/ixtlan-remote'

  s.authors = ['Christian Meier']
  s.email = ['m.kristian@web.de']

  s.license = "AGPL3"

  s.files += Dir['lib/**/*']
  s.files += Dir['spec/**/*']
  s.files += Dir['agpl-3.0.txt']
  s.files += Dir['*.md']
  s.files += Dir['Gemfile']

  s.test_files += Dir['spec/**/*_spec.rb']
  s.add_dependency 'rest-client', '~> 1.6.3'
  s.add_development_dependency 'rake', '= 10.0.2'
  s.add_development_dependency 'minitest', '4.3.2'
  s.add_development_dependency 'activesupport', '~> 3.2'
  s.add_development_dependency 'dm-sqlite-adapter', '1.2.0'
  s.add_development_dependency 'dm-migrations', '1.2.0'
  s.add_development_dependency 'dm-aggregates', '1.2.0'
  s.add_development_dependency 'webmock', '~> 1.8'
  s.add_development_dependency 'copyright-header', '~>1.0'
  s.add_development_dependency 'json', '~>1.7'
end
