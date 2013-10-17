source 'https://www.rubygems.org'

gem 'endpoint_base', :git => 'git@github.com:spree/endpoint_base.git'
gem 'capistrano'
gem 'httparty'

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
