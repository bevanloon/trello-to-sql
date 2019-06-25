require 'faraday'
require './secrets'
require './database'
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

def board(board_id)
  json_response "boards/#{board_id}"
end

def print_boards
  boards.each do |board|
    puts "#{board["id"]}, #{board["name"]}"
  end
end

def cards_for_board(board_id)
  json_response "boards/#{board_id}/cards"
end

def push_cards_to_db(board_id)
  data = Database.new
  cards = cards_for_board(board_id)
  cards.each do | card |
    data.insert_card(card["name"], card["desc"])
  end
end
