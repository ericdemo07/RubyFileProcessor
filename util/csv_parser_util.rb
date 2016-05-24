require 'csv'
require_relative 'db_util'

class CSV_Parser
  def csv_parser(log)
    conf = YAML.load_file('../conf/local.yml')
    download_path = File.expand_path(conf['path']['destination_path'], File.dirname(__FILE__))
    db_instance = DB_Utility.new(log)
    CSV.foreach(download_path, converters: :numeric) do |row|
      if row[4] == conf['compare_keyword']
        db_instance.insert_data(row[0], row[1], row[2])
      end
    end
    log.info('__CSVProcessing completed successfully__')
  end
end
