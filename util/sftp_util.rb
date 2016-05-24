require 'net/sftp'
require_relative 'csv_parser_util'

class Sftp_Utility < CSV_Parser
  attr_reader :conf, :log

  def initialize(host, username, password, log)
    @log = log
    @conf = YAML.load_file('../conf/local.yml')
    sftp_file(host, username, password)
  end

  def sftp_file(host, username, password)
    Net::SFTP.start(host, username, password: password) do |sftp|
      source_path = File.expand_path(conf['path']['source_path'], File.dirname(__FILE__))
      download_path = File.expand_path(conf['path']['destination_path'], File.dirname(__FILE__))
      sftp.download!(source_path, download_path)
      log.info("File successfully FTPed to #{download_path}")
    end
    csv_parser(log)
  end
end
