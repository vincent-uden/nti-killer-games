def dp(str)
  call = caller_locations(1, 1)[0]
  path = call.path().split "nti-killer-games"
  path = path[1]
  print "#{path}:#{call.lineno()} "
  p str
end
