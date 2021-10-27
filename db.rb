require 'yaml'
require 'active_record'

databaseConfigFile = File.open('dbconfig.yaml')
databaseConfig = YAML::load(databaseConfigFile)
ActiveRecord::Base.establish_connection(databaseConfig)

class DeviceDatum < ActiveRecord::Base
end