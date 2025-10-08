puts IO.readlines("done.txt").select {|i| i[0] == '+'}.sample
