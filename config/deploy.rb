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

set :rvm_ruby_version, 'ruby-2.3.6'
set :rvm_do, "~/.rvm/bin/rvm #{fetch(:rvm_ruby_version)} do"

namespace :deploy do
  desc "Setup env"
  task :setup_env do
    on roles :all do
      execute  <<-CMD
        RACK_ENV=#{fetch(:rack_env)}; echo 'RACK_ENV=#{fetch(:rack_env)}'; cd #{fetch(:release_path)}; #{fetch(:rvm_do)} ruby #{fetch(:release_path)}/env.rb
      CMD
    end
  end

  before 'deploy:restart', 'deploy:setup_env'

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'deploy:start'
      invoke 'deploy'
    end
  end

  desc "Start the Thin processes"
  task :start do
    on roles :all do
      execute  <<-CMD
        cd #{fetch(:release_path)}; #{fetch(:rvm_do)} bundle exec thin start -C thin.yml
      CMD
    end
  end

  desc "Stop the Thin processes"
  task :stop do
    on roles :all do
      execute <<-CMD
        cd #{fetch(:release_path)}; #{fetch(:rvm_do)} bundle exec thin stop -C thin.yml
      CMD
    end
  end

  desc "Restart the Thin processes"
  task :restart do
    on roles :all do
      execute <<-CMD
        cd #{fetch(:release_path)}; #{fetch(:rvm_do)} bundle exec thin restart -C thin.yml
      CMD
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
