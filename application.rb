['./websitestatussvc/.env', './avatarsvc/.env', './locationfetchsvc/.env', './timezonesvc/.env'].select {|f| File.file?(f)}.join(' ').tap do |files|
  `cat #{files} > .env`
end

require 'dotenv'
Dotenv.load

require './locationfetchsvc/application.rb'
require './avatarsvc/application.rb'
require './timezonesvc/application.rb'
require './websitestatussvc/application.rb'
require 'exception_notification'
require 'sinatra'

module RollFindrServices
    class ExceptionHandler < Sinatra::Application
    use ExceptionNotification::Rack,
    :email => {
      :email_prefix => "[Services.BJJMapper] ",
      :sender_address => %{"Exception Notifier" <errors@bjjmapper.com>},
      :exception_recipients => %w{evan@bjjmapper.com},
      :smtp_settings => {
        :address              => "smtp.gmail.com",
        :port                 => 587,
        :domain               => 'bjjmapper.com',
        :user_name            => ENV['MAILER_USER'],
        :password             => ENV['MAILER_PASS'],
        :authentication       => 'plain',
        :enable_starttls_auto => true
      }
    }

    error do
      status 500
      url = request.url
      e = env['sinatra.error']
      puts "Caught exception #{e.backtrace.join("\n")}"

      ExceptionNotifier.notify_exception(e, :data => { :url => request.url })
    end
  end
end

puts "Starting services in #{ENV['RACK_ENV']} environment"
