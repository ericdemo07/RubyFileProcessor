require 'sqlite3'

class DB_Utility
  attr_reader :target_date, :record_count, :total_points, :db, :db_path, :log

  def initialize(log)
    @log = log
    conf = YAML.load_file('../conf/local.yml')
    @db_path = File.expand_path(conf['db_path'], File.dirname(__FILE__))
    time = Time.now.strftime('%Y-%m-%d')
    @target_date = Date.parse(time)
    @total_cash_rewards = 0
    @record_count = 0
    File.delete(db_path) if File.exist? db_path
  end

  def initialize_table
    @db.execute <<-SQL
      CREATE TABLE assign_cash_reward (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        grant_date TEXT NOT NULL,
        user_rank TEXT NOT NULL,
        cash_reward TEXT NOT NULL,
        try_count INTEGER NOT NULL DEFAULT 0,
        status TEXT NOT NULL DEFAULT 'New',
        UNIQUE(user_id, user_rank)
      )
    SQL
    @log.info('table with tablename "assign_cash_reward" created')
  end

  def open_db
    @db = SQLite3::Database.new(db_path)
    initialize_table
  end

  def insert_data(user_id, user_rank, cash_reward)
    open_db unless db
    query = <<-SQL
      INSERT INTO assign_cash_reward(grant_date, user_id, user_rank, cash_reward)
      VALUES(:grant_date, :user_id, :user_rank, :cash_reward)
    SQL
    begin
      @db.execute(query,
                  grant_date: target_date.strftime('%Y%m%d'),
                  user_id: user_id,
                  user_rank: user_rank,
                  cash_reward: cash_reward)
      @total_cash_rewards += cash_reward.to_i
    rescue SQLite3::ConstraintException, SQLite3::SQLException => e
      raise
    end
    @record_count += 1
  end
  #  @log.info("Total new records inserted : #{@record_count}")
end
