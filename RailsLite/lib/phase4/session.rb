require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      json_cookie = req.cookies.find { |cookie| cookie.name == '_rails_lite_app' }
      @cookie_val = json_cookie ? JSON.parse(json_cookie.value) : {}
    end

    def [](key)
      @cookie_val[key]
    end

    def []=(key, val)
      @cookie_val[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', @cookie_val.to_json)
    end
  end
end
