# -*- coding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'ixtlan-remote'
  s.version = '0.1.0'

  s.summary = ''
  s.description = ''
  s.homepage = 'https://github.com/mkristian/ixtlan-remote'

  s.authors = ['Kristian Meier']
  s.email = ['m.kristian@web.de']

  s.files += Dir['lib/**/*']
  s.files += Dir['spec/**/*']
  s.files += Dir['MIT-LICENSE'] + Dir['*.md']
  s.files += Dir['Gemfile']

  s.test_files += Dir['spec/**/*_spec.rb']
  s.add_dependency 'rest-client', '~> 1.6.3'
  s.add_development_dependency 'rake', '= 0.9.2.2'
  s.add_development_dependency 'minitest', '3.3.0'
  s.add_development_dependency 'activesupport', '3.2.7'
  s.add_development_dependency 'dm-sqlite-adapter', '1.2.0'
  s.add_development_dependency 'dm-migrations', '1.2.0'
  s.add_development_dependency 'dm-aggregates', '1.2.0'
  s.add_development_dependency 'webmock', '1.8.9'
end
