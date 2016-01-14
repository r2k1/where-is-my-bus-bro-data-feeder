require 'net/http'
require 'uri'
require 'json'

class ATApi
    BASE_URL = 'https://api.at.govt.nz/v1'
    def get_locations
      uri = build_uri('public/realtime/vehiclelocations')
      json = Net::HTTP.get(uri)
      JSON.parse(json)
    end

    def get_routes
      uri = build_uri('gtfs/routes')
      json = Net::HTTP.get(uri)
      JSON.parse(json)
    end

    private

    def build_uri(location)
      URI("#{BASE_URL}/#{location}?api_key=#{ENV['AT_API_KEY']}")
    end
end
