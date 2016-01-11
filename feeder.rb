require_relative 'auckland_transport_api'
require 'mongo'
require 'pry'
require 'dotenv'

Dotenv.load
Mongo::Client.new(ENV['MONGO_URL'])
data = AucklandTranportApi.get_data(106)

def format(data)
  data["response"]["movements"].map do |bus|
    out = {
      timestamp:                Time.parse(bus['timestamp']),
      destination:              bus['destinationDisplay'],
      stop_code:                bus['stop_code'],
      scheduled_arrival_time:   Time.parse(bus['scheduledArrivalTime']),
      scheduled_departure_time: Time.parse(bus['scheduledArrivalTime']),
      route_short_name:         bus['route_short_name']
    }
    out[:expected_arrival_time] = Time.parse(bus['expectedArrivalTime']) if bus['expectedArrivalTime']
    out[:expected_departure_time] = Time.parse(bus['expectedDepartureTime']) if bus['expectedDepartureTime']
    out
  end
end

Pry::ColorPrinter.pp(format(data))
