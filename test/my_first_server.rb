require 'webrick'

server = WEBrick::HTTPServer.new Port: 8080
trap('INT') { server.shutdown }



server.mount_proc '/' do |req, res|
  Mycontroller.new(req, res).go
end

server.start