source 'https://rubygems.org'

gem 'rake'

gem 'sequel'
gem 'mysql2', platform: :ruby
gem 'jdbc-mysql', platform: :jruby

gem 'sinatra'
gem 'rack-flash3'

gem 'macmillan-utils', git: 'git@github.com:nature/macmillan-utils.git', require: false

gem 'unicorn', require: false, platform: :ruby
gem 'puma', require: false

gem 'airbrake', require: false

group :development do
  gem 'shotgun'
  gem 'rubocop'
end

group :test do
  gem 'sqlite3', platform: :ruby
  gem 'jdbc-sqlite3', platform: :jruby
  gem 'rspec'
  gem 'rack-test'
  gem 'capybara'
  gem 'poltergeist'
  gem 'webmock'
  gem 'pry'
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem 'codeclimate-test-reporter'
end

