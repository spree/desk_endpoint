source 'https://www.rubygems.org'

gem 'httparty'

gem 'sinatra'
gem 'tilt', '~> 1.4.1'
gem 'tilt-jbuilder', require: 'sinatra/jbuilder'

group :test do
  gem 'vcr'
  gem 'rspec', '2.11.0'
  gem 'webmock', '1.11.0'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'rack-test'
  gem 'debugger'
end

group :production do
  gem 'foreman'
  gem 'unicorn'
end

gem 'pry', group: :development
gem 'endpoint_base', :git => 'git@github.com:spree/endpoint_base.git', :branch => 'v5'
