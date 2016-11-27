require 'erb'
require 'fileutils'
require 'dotenv'
Dotenv.load

thin_config = ERB.new(File.read("thin.yml.erb"))
File.open("thin.yml", "w") do |file|
  file.write(thin_config.result)
  file.close()
end

FileUtils.ln_s 'avatarsvc/uploads', 'uploads'

