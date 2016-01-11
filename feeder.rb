require_relative 'auckland_transport_api'
require_relative 'schedule_formatter'
require 'mongo'
require 'pry'
require 'dotenv'

Dotenv.load
data = AucklandTranportApi.get_data(106)
data = ScheduleFormatter.format(data)

stop_codes = data.uniq { |d| d[:stop_code] }.map { |d| d[:stop_code] }
mongo_client = Mongo::Client.new(ENV['MONGO_URL'])
schedules = mongo_client[:schedules]
schedules.find('bus_stop': {'$in': stop_codes}).delete_many
schedules.insert_many(data)

Pry::ColorPrinter.pp(data)
