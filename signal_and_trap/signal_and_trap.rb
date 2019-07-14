# $ kill -s info [PID]
# or ctrl-T

Signal.trap(:INFO) {
  p "trap!!!"
}

while true
  puts "hi"
  sleep 1
end
