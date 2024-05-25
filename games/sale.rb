require 'cgi'


def check_sales(title)
  search = CGI.escape title

  `open https://www.gog.com/en/games?query=#{search}`
  `open https://store.epicgames.com/en-US/browse?q=#{search}`
  `open https://store.steampowered.com/search/?term=#{search}`
end

if ARGV[0]
  check_sales ARGV[0]
else
  IO.readlines("all.txt").map!(&:strip).each do |i|
    check_sales(i)
    sleep 1
    exit
  end
end