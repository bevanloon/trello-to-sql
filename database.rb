require "sqlite3"

class Database
  def db
    @db ||= SQLite3::Database.new "trello_cards.db"
  end

  def initialize
    unless table_exists?("cards") > 0
      db.execute <<-SQL
        create table cards (
          title text,
          description text
        );
      SQL
      puts "Created table cards"
    else
      puts "Table exists"
    end
  end

  def insert_card(title, description)
    sql = "insert into cards(title, description) values(?, ?)"
    db.execute(sql, title, description)
  end

  private
  def table_exists?(table_name)
    db.get_first_value <<-SQL
      select count(*) from sqlite_master where type="table" and name="#{table_name}"
    SQL
  end
end
