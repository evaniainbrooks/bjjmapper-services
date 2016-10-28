['./avatarsvc/.env', './locationfetchsvc/.env', './timezonesvc/.env'].each do |file|
  result = system "source #{file}"
  puts result
end
