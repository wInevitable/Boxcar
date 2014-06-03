require 'json'
require 'webrick'
require 'debugger'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(http_req)
    @cookie = parse_cookie(http_req)
  end

  def [](key)
  end

  def []=(key, val)
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
  end
  
  private
  
  def parse_cookie(http_req)
    cookies = http_req.cookies
    cookies.each do |cookie|
      if cookie.name == "_rails_lite_app"
        @cookie = JSON.parse(cookie.value)
      else
        @cookie = {}
      end
    end
    
    @cookie
  end
end
