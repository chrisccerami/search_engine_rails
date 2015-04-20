sites = YAML::load(File.open("./db/sites.yml"))

sites.each do |site|
  link = Link.create(url: site[1])
  puts "Created Link with id: #{link.id} and url: #{link.url}"
end
