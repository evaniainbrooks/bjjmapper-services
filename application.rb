['./avatarsvc/.env', './locationfetchsvc/.env', './timezonesvc/.env'].select {|f| File.file?(f)}.join(' ').tap do |files|
  `cat #{files} > .env`
end

require 'dotenv'
Dotenv.load

require './locationfetchsvc/application.rb'
require './avatarsvc/application.rb'
require './timezonesvc/application.rb'

puts "Starting services in #{ENV['RACK_ENV']} environment"
