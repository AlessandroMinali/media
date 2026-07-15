require "uri"

IO.readlines("list.txt").sample(3).each do |book|
  query = URI.encode_uri_component(book.strip)
  `open https://www.indigo.ca/search?q=#{query}`
  `open https://www.amazon.ca/s?k=#{book.gsub(" ", '+')}`
end
