#!/usr/bin/env ruby
# frozen_string_literal: true

DATA = IO.readlines("#{__dir__}/spotify.txt", chomp: true)

def save
  IO.write("#{__dir__}/spotify.txt", DATA.join("\n"))
  exit(0)
end

Signal.trap('INT') { save }

puts 'Spotify Song List'
loop do
  print '>> '
  save if gets.chomp == 'exit'
  song = DATA.shift
  puts song
  `open "https://yewtu.be/search?q=#{song}"`
  # `open "https://vid.puffyan.us/search?q=#{song}"`
end
