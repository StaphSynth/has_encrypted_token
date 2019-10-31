# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'has_protected_token'
  s.version     = '0.1.0'
  s.date        = '2019-10-06'
  s.summary     = 'Easily generate random tokens for any ActiveRecord model and store them securely in the database.'
  s.description = 'Generate random tokens (or use your own) for any ActiveRecord model. Hashes and salts the token before storage in the database using the same methodology as has_secure_password.'
  s.author      = 'David Allen'
  s.email       = '1337dallen@gmail.com' # yes, I know it's a terrible email address...
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/StaphSynth/has_protected_token'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2.3'

  s.add_dependency 'activerecord', '>= 4.2'
  s.add_dependency 'bcrypt', '~> 3.1.1'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'bump'
  s.add_development_dependency 'bundler', '~> 1.17.3'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'wwtd'
end
