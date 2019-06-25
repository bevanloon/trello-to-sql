require 'faraday'
require './secrets'
require 'json'

include Secrets

def conn
  @conn ||= Faraday.new(url: "https://api.trello.com/1")
end

def key_and_token
  "key=#{Secrets.key}&token=#{Secrets.token}"
end

def json_response(path)
  path_and_auth = path + "?#{key_and_token}"
  JSON.parse(conn.get(path_and_auth).body)
end

def boards
  json_response "members/me/boards"
end

def print_boards
  boards.each do |board|
    puts "#{board["id"]}, #{board["name"]}"
  end
end

def board(board_id)
  json_response "boards/#{board_id}"
end
