games = IO.readlines('xbox.txt').map!(&:strip).sort{ |a,b| a.downcase <=> b.downcase }

def bin_string(haystack, needle)
  _needle = needle.downcase
  head = 0
  tail = haystack.length - 1

  while(head != tail) do
    mid = ((head + tail) / 2.0).ceil
    if haystack[mid].downcase[0] > _needle[0]
      tail = mid - 1
    else
      head = mid
    end
  end
  return "#{needle} closest: #{haystack[head]}" if haystack[head][0].downcase != _needle[0]

  direction = nil
  while (haystack[head].downcase[0] == _needle[0])
    r = haystack[head].downcase <=> _needle
    return "#{needle} match: #{haystack[head]}" if r.zero?
    head -= r

    return "#{needle} closest: #{haystack[head]}" if direction && direction != r
    direction = r
  end
  return "#{needle} closest: #{haystack[head + direction]}"
end

matches = []
IO.readlines('all.txt').map{ |x| x.strip }.each do |i|
  r = bin_string(games, i)
  matches << r if r =~ /match/
end
puts "Game Pass matches: #{matches.length}"
puts matches