require 'faraday'
require './secrets'

include Secrets

conn = Faraday.new(url: "https://api.trello.com/1")

response = conn.get "members/me/boards?key=#{Secrets.key}&token=#{Secrets.token}"
puts response.body
