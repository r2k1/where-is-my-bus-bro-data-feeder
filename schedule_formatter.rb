class ScheduleFormatter
  def self.format(data)
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
end
