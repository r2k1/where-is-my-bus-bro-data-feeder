require 'net/http'
require 'uri'
require 'json'

class ATApi
    BASE_URL = 'https://api.at.govt.nz/v1/public'
    def self.get_locations
      uri = build_uri('realtime/vehiclelocations')
      json = Net::HTTP.get(uri)
      JSON.parse(json)
    end

    private
    def self.build_uri(location)
      URI("#{BASE_URL}/#{location}?api_key=#{ENV['AT_API_KEY']}")
    end
end
