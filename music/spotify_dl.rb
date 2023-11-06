require 'net/http'
require 'cgi'

THREADS = 4
DATA = IO.readlines("#{__dir__}/spotify.txt", chomp: true)

DATA.each_slice((DATA.length / THREADS).ceil) do |block|
  fork do
    block.each do |str|
      # uri = URI("https://www.google.com/search?q=#{CGI::escape(str)}+site%253Ayoutube.com")
      uri = URI("https://vid.puffyan.us/search?q=#{CGI::escape(str)}")
      Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
        request = Net::HTTP::Get.new uri
        request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/#{rand(1000)}.#{rand(100)}"
        response = http.request(request)

        next if response.code.to_i != 200
        
        # match = CGI.unescape(response.body.match(/(https:\/\/www.youtube.com\/watch.+?)&/)[0])
        match = CGI.unescape(response.body.match(/(\/watch.+?)\"/)[1])

        `yt-dlp --no-mtime -x --audio-format mp3 https://vid.puffyan.us#{match}` if match
        puts str
      end
    # rescue => e
    #   puts "Failed: #{str}"
    end
    puts "PROCESS: finished."
  end
end

# comm -3 <(sort spotify.txt) <(sort spotify_dl.txt) | shuf -o spotify.txt
