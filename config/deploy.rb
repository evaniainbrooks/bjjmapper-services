# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'rollfindr_services'
set :repo_url, 'eibjj@bitbucket.org:rollfindr/rollfindr_services.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rvm_ruby_version, 'ruby-2.1.1'

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      puts `git rev-parse HEAD`
      #unless `git rev-parse HEAD` == `git rev-parse bitbucket/master`
      #  puts "WARNING: HEAD is not the same as bitbucket/master"
      #  puts "Run `git push` to sync changes."
      #  exit
      #end
    end
  end
  
  desc "Start the Thin processes"
  task :start do
    run  <<-CMD
      cd /var/www/rollfindr_services/current; bundle exec thin start -C thin.yml
    CMD
  end

  desc "Stop the Thin processes"
  task :stop do
    run <<-CMD
      cd /var/www/rollfindr_services/current; bundle exec thin stop -C thin.yml
    CMD
  end

  desc "Restart the Thin processes"
  task :restart do
    run <<-CMD
      cd /var/www/rollfindr_services/current; bundle exec thin restart -C thin.yml
    CMD
  end
  
  before :starting, :check_revision
end
