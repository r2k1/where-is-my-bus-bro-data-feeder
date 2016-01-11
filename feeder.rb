require_relative 'auckland_transport_api'
require_relative 'timetable_formatter'
require 'mongo'
require 'pry'
require 'dotenv'

Dotenv.load
data = AucklandTranportApi.get_data(106)
data = TimetableFormatter.format(data)

stop_codes = data.uniq { |d| d[:stop_code] }.map { |d| d[:stop_code] }
mongo_client = Mongo::Client.new(ENV['MONGO_URL'])
timetable = mongo_client[:timetable]
timetable.delete_many(stopCode: {'$in': stop_codes})
timetable.insert_many(data)
Pry::ColorPrinter.pp(data)
