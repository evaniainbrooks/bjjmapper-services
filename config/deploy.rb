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
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'deploy:start'
      invoke 'deploy'
    end
  end
  
  desc "Start the Thin processes"
  task :start do
    run  <<-CMD
      cd /var/www/rollfindr_services/current; bundle exec thin start -C config/thin.yml
    CMD
  end

  desc "Stop the Thin processes"
  task :stop do
    run <<-CMD
      cd /var/www/rollfindr_services/current; bundle exec thin stop -C config/thin.yml
    CMD
  end

  desc "Restart the Thin processes"
  task :restart do
    run <<-CMD
      cd /var/www/rollfindr_services/current; bundle exec thin restart -C config/thin.yml
    CMD
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
