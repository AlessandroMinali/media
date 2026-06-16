require "uri"
require "net/http"

path = File.join(__dir__, "all.txt")

USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) " \
  "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

def status_for(url)
  uri = URI(url)
  request = Net::HTTP::Get.new(uri)
  request["User-Agent"] = USER_AGENT
  Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
    http.request(request).code.to_i
  end
rescue StandardError => e
  warn "request failed: #{e.message}"
  0
end

MIN_DELAY = 0.5
delay = MIN_DELAY

File.foreach(path) do |line|
  name = line.strip
  next if name.empty?

  query = URI.encode_www_form_component(name)
  url = "https://store.steampowered.com/search/?term=#{query}"

  while status_for(url) == 429
    warn "429 for #{name}, backing off #{delay}s"
    sleep delay
    delay *= 2
  end

  system("open", "-a", "Safari", url)
  sleep delay
  delay = [delay / 2, MIN_DELAY].max
end
