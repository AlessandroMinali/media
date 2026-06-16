require "uri"

path = File.join(__dir__, "all.txt")

File.foreach(path) do |line|
  name = line.strip
  next if name.empty?

  query = URI.encode_www_form_component(name)
  url = "https://www.gog.com/en/games?query=#{query}"
  system("open", "-a", "Safari", url)
  sleep 1
end
