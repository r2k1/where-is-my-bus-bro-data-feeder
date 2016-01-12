require_relative 'auckland_transport_api'
require_relative 'timetable_formatter'

require 'mongo'
require 'dotenv'




def get_stop_number(number)
  data = AucklandTranportApi.get_data(number)
  return unless data['status'] == 'OK'
  data = TimetableFormatter.format(data)
  stops_count = data.map { |d| d[:stopCode] }.uniq.count
  return if stops_count != 1
  data[0][:stopCode].to_i
end
  

Dotenv.load
mongo_client = Mongo::Client.new(ENV['MONGO_URL'])
stops = mongo_client[:stops]
stops.delete_many
queue = Queue.new
threads = []
10000.times { |i| queue << i }
100.times do
  threads << Thread.new do
    while(queue.length > 0) do
      index = queue.pop
      p index
      number = get_stop_number(index)
      next unless number == index
      p 'FOUND'
      stops.insert_one({stopCode: number})
    end
  end
end
threads.map(&:join)
