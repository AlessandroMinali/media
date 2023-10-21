#!/usr/bin/env ruby

data = IO.readlines('spotify.txt', chomp: true)

puts "Spotify Song List"
loop do
  print ">> "
  save if gets.chomp == 'exit'
  `open https://yewtu.be/search?q=#{data.shift.join(" ")}`
  puts
end

def save
  IO.write('spotify.txt', data)
end

Signal.trap('INT') do
  puts 'abort'
  save
  exit(0)
end