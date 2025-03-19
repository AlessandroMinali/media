require 'net/http'
require 'uri'
require 'cgi'

# Read the text file
File.open('songs.txt', 'r') do |file|
  file.each_line do |line|
    # Extract song and artist names
    song, artist = line.strip.split(' - ')

    # Construct the search URL
    url = "https://www.youtube.com/results?search_query=#{CGI.escape("#{song} #{artist}")}"

    # Send an HTTPS request to the search URL
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.get(uri.request_uri)

    # Parse the HTML response manually
    video_id = nil
    response.body.each_line do |line|
      if line.include?('watch?v=')
        video_id = line.split('watch?v=').last.split('"').first
        break
      end
    end

    # Get the first result URL
    if video_id
      `open https://www.youtube.com/watch?v=#{video_id}`
      puts "#{song} - #{artist}: #{url}"
    else
      puts "#{song} - #{artist}: No results found"
    end
  end
end
