require "sqlite3"

class Database
  def db
    @db ||= SQLite3::Database.new "trello_cards.db"
  end

  def initialize
    unless table_exists?("cards") > 0
      db.execute <<-SQL
        create table cards (
          id integer primary key autoincrement,
          trello_id text,
          title text,
          description text,
          trello_url text
        );
      SQL
      puts "Created table `cards`"
    else
      puts "`cards` table exists"
    end

    unless table_exists?("checklists") > 0
      db.execute <<-SQL
        create table checklists (
          id integer primary key autoincrement,
          card_id integer,
          title text,
          trello_id text
        );
      SQL
      puts "Created table `checklists`"
    else
      puts "`checklists` table exists"
    end
  end

  def insert_card(title, description, trello_id, trello_url)
    sql = "insert into cards(title, description, trello_id, trello_url) values(?, ?, ?, ?)"
    db.execute(sql, title, description, trello_id, trello_url)
    db.last_insert_row_id
  end

  def insert_checklist_item(card_id, title, trello_id)
    sql = "insert into checklists(card_id, title, trello_id) values(?, ?, ?)"
    db.execute(sql, card_id, title, trello_id)
  end

  private
  def table_exists?(table_name)
    db.get_first_value <<-SQL
      select count(*) from sqlite_master where type="table" and name="#{table_name}"
    SQL
  end
end
