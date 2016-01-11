class TimetableFormatter
  def self.format(data)
    return [] unless data['response'] && data['movements']
    data['response']['movements'].map do |bus|
      out = {
        timestamp:                Time.parse(bus['timestamp']),
        destination:              bus['destinationDisplay'],
        stopCode:                 bus['stop_code'],
        routeShortName:           bus['route_short_name']
      }
      if bus['scheduledArrivalTime']
        out[:scheduledDepartureTime] = Time.parse(bus['scheduledArrivalTime'])
      end
      if bus['scheduledArrivalTime']
        out[:scheduledArrivalTime] = Time.parse(bus['scheduledArrivalTime'])
      end
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
