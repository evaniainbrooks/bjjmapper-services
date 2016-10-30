source 'https://rubygems.org'
ruby '2.1.1'

gem 'dotenv'
group :test, :development do
  gem 'capistrano', '~> 3.2.1'
  gem 'capistrano-bundler'
end

gemfiles = [ 'locationfetchsvc/Gemfile', 'timezonesvc/Gemfile', 'avatarsvc/Gemfile' ]
gemfiles.each do |gemfile|
  eval_gemfile gemfile
end
