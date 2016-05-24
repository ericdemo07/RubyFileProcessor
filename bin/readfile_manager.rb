require_relative '../util/sftp_util'
require 'yaml'
require 'log4r'

class CSVProcessing_ssh
  def initialize
    time = Time.new
    conf = YAML.load_file(File.expand_path('../conf/local.yml', File.dirname(__FILE__)))
    logname = conf['logpath'] + time.strftime('%Y%m%d')
    logpath = File.expand_path(logname, File.dirname(__FILE__))
    log = Logger.new logpath
    log.info '__start csv processing__'
    Sftp_Utility.new(conf['sftp']['hostip'], conf['sftp']['username'], '', log)
  end
end
CSVProcessing_ssh.new
