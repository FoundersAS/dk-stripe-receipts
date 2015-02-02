source 'https://rubygems.org'

ruby '2.2.0'

gem 'rack'
gem 'sinatra'
gem 'oauth2'
gem 'stripe'
gem 'dotenv', group: [:development, :test]
gem 'pg'
gem 'sequel'
gem 'pony'

group :test do
  gem 'rspec'
  gem 'backtrace_shortener', require: nil
  gem 'rack-test', require: nil
  gem 'webmock', require: nil
  gem 'database_cleaner', require: nil
end

group :test, :development do
  gem 'pry'
end

