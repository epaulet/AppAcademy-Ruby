require 'addressable/uri'
require 'rest-client'

user_url = Addressable::URI.new(
  scheme: 'http',
  host: 'localhost',
  port: 3000,
  path: '/contacts'
).to_s

p RestClient.get(user_url)
