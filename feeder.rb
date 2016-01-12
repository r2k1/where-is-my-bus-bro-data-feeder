require_relative 'auckland_transport_api'
require_relative 'timetable_formatter'
require 'mongo'
require 'pry'
require 'dotenv'

Dotenv.load


mongo_client = Mongo::Client.new(ENV['MONGO_URL'])
stops = mongo_client[:stops]
stops.find.each do |stop|
  data = AucklandTranportApi.get_data(stop['apiId'])
  data = TimetableFormatter.format(data)
  stops.update_one({ _id: stop['_id'] }, { '$set' => { timetable: data }})
end
