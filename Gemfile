source 'https://rubygems.org'
ruby '2.3.6'

gem 'dotenv', require: false
gem 'newrelic_rpm'

gem 'exception_notification'
group :test, :development do
  gem 'capistrano', '~> 3.2.1'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm', require: false
  gem 'rubocop'
end

gemfiles = [ 'locationfetchsvc/Gemfile', 'timezonesvc/Gemfile', 'avatarsvc/Gemfile', 'websitestatussvc/Gemfile' ]
gemfiles.each do |gemfile|
  eval_gemfile gemfile
end
