require 'rubygems'

root_dir = File.dirname(__FILE__)
app_file = File.join(root_dir, 'application.rb')
require app_file

set :environment, ENV['RACK_ENV'].to_sym
set :root,        root_dir
set :app_file,    app_file
set :server,      'thin'
disable :run

use AvatarService::Application
use TimezoneService::Application
use LocationFetchService::Application
run RollFindrServices::ExceptionHandler
