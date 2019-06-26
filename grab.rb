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

def json_response(path, options=nil)
  querystring = "?#{options}&#{key_and_token}" if options
  querystring = "?#{key_and_token}" unless querystring
  path_and_auth = path + querystring
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
  json_response "boards/#{board_id}/cards", "checklists=all"
end

def data
  @db_connection ||= Database.new
end

def push_cards_to_db(board_id)
  cards = cards_for_board(board_id)
  cards.each do |card|
    card_id = data.insert_card(card["name"], card["desc"], card["id"], card["shortUrl"])
    push_checklists_to_db(card_id, card["checklists"])
  end
end

def push_checklists_to_db(card_id, checklists)
  return unless checklists
  check_items = checklists.collect {|checklist| checklist["checkItems"]}.flatten
  check_items.each do |check_item|
    data.insert_checklist_item(card_id, check_item["name"], check_item["id"])
  end
end

def control(args)
  if args.any?
    action = args[0]
    option = args[1] if args[1]
    case action
    when "boards"
      print_boards
    when "board"
      puts board(option)
    when "cards"
      puts cards_for_board(option)
    when "savecards"
      push_cards_to_db(option)
    end
  else
    puts "No args"
  end
end

control ARGV
