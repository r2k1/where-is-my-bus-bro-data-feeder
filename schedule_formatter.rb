class ScheduleFormatter
  def self.format(data)
    data["response"]["movements"].map do |bus|
      out = {
        timestamp:                Time.parse(bus['timestamp']),
        destination:              bus['destinationDisplay'],
        stopCode:                 bus['stop_code'],
        scheduledArrivalTime:     Time.parse(bus['scheduledArrivalTime']),
        scheduledDepartureTime:   Time.parse(bus['scheduledArrivalTime']),
        routeShortName:           bus['route_short_name']
      }
      if bus['expectedArrivalTime']
        out[:expectedArrivalTime] = Time.parse(bus['expectedArrivalTime'])
      end
      if bus['expectedDepartureTime']
        out[:expectedDepartureTime] = Time.parse(bus['expectedDepartureTime'])
      end
      out
    end
  end
end
