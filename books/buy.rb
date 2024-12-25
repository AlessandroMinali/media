IO.readlines("list.txt").sample(3).each do |book|
  `open https://www.indigo.ca/en-ca/search?q=#{book.gsub(" ", '+')}`
  `open https://www.amazon.ca/s?k=#{book.gsub(" ", '+')}`
end
