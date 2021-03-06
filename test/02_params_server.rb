require 'active_support/core_ext'
require 'json'
require 'webrick'
require_relative '../lib/rails_lite'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class ExampleController < ControllerBase
  def create
    render_content(params.to_s, "text/json")
  end

  def new
    page = <<-END
<form action="/" method="post">
  <label for="name">Cat Name</lanel>
  <input id="name" type="text" name="cat[name]">
  <label for="owner">Cat Owner</label>
  <input id="owner" type="text" name="cat[owner]">

  <input type="submit">
</form>
END

    render_content(page, "text/html")
  end
end

server.mount_proc '/' do |req, res|
  case req.path
  when '/'
    contr = ExampleController.new(req, res, {}).create
  when '/new'
    contr = ExampleController.new(req, res, {}).new
  end
end

server.start
