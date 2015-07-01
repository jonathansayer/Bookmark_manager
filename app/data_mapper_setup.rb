require 'data_mapper'
require_relative './models/tag'

env = ENV['RACK_UP'] || "development"

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require_relative './models/link'

DataMapper.finalize

DataMapper.auto_migrate!
